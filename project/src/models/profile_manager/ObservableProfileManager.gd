#
#  ObservableProfileManager.gd
#  Copyright 2021 ItJustWorksTM
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
class_name ObservableProfileManager

extends Signaler

# The signals emitted upon a successful call to some of the functions
signal profiles_loaded
signal orig_profile_loaded
signal profile_saved
signal profiles_saved
signal active_profile_changed
signal orig_profile_changed



# Fake variables that mimic those in the actual ProfileManager
# (included here so we don't break any current references to them)
var active_profile = null setget set_active_profile, get_active_profile
var orig_profile = null setget set_orig_profile, get_orig_profile
var saved_profiles = null setget set_saved_profiles, get_saved_profiles

# The object we are wrapping (ProfileManager)
var _profile_manager = ProfileManager2.new()

func _init():
	name = "ObservableProfileManager"

# The wrapping functions that emit signals upon success
func load_profile(profile) -> void:
	var success = _profile_manager.load_profile(profile)
	_profile_manager.active_profile.connect("profile_changed", self, "_on_active_profile_changed")
	if success: Signals.emit_signal("profile_loaded", profile)
	
func load_profiles() -> Array:
	var result = _profile_manager.load_profiles()
	var success = (result != null) and (result != [])
	if success: emit_signal("profiles_loaded", result)
	return result

func load_active_profile() -> void:
	var success = _profile_manager.load_active_profile()
	if success: 
		emit_signal("active_profile_loaded", _profile_manager.active_profile)
		Signals.emit_signal("profile_loaded", _profile_manager.active_profile)

func load_orig_profile() -> void:
	var success = _profile_manager.load_orig_profile()
	if success: 
		emit_signal("orig_profile_loaded", _profile_manager.orig_profile)
		Signals.emit_signal("profile_loaded", _profile_manager.orig_profile)
	
func save_profile(profile) -> void:
	var success = _profile_manager.save_profile(profile)
	if success: emit_signal("profile_saved", profile)	
		
func save_profiles(profiles: Array) -> void:
	var success = _profile_manager.save_profiles(profiles)
	if success: emit_signal("profiles_saved", profiles)

# Wrapping getters and setters
func get_active_profile():
	return _profile_manager.active_profile

func set_active_profile(value):
	_profile_manager.active_profile = value
	
	if value != null:
		# Connect to the new active profile, to get signaled when its variables change
		value.connect("profile_changed", self, "_on_active_profile_changed")
		# Send signal that the active profile has changed (e.g. so the save button gets updated)
		emit_signal("active_profile_changed", value)

func get_orig_profile():
	return _profile_manager.orig_profile	
	
func set_orig_profile(value):
	_profile_manager.orig_profile = value
	
	if value != null:
		value.connect("profile_changed", self, "_on_orig_profile_changed")
	
func get_saved_profiles():
	return _profile_manager.saved_profiles	
	
func set_saved_profiles(value):
	_profile_manager.saved_profiles = value

# SIGNAL HANDLERS
func _on_active_profile_changed(active_profile) -> void:
	emit_signal("active_profile_changed", active_profile)
	
func _on_orig_profile_changed(orig_profile) -> void:
	emit_signal("orig_profile_changed", orig_profile)
