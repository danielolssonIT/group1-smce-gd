#
#  ProfileSelectorViewModel.gd
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


extends Node

# var from Master.gd
var master_t = load("res://src/ui/master_control/Master.gd")
var _master  = null

# this var triggers when setting the profile_selector in other script
var profile_selector_view = null setget set_view, get_view

var orig_profile: ProfileConfig = null
var active_profile: ProfileConfig = null


func _init():
	print("ProfileSelectorViewModel")

	
func _ready() -> void:
	print("IN READY")


func _on_profile_selected(profile: ProfileConfig) -> void:
	print("ProfileSelectorViewModel: on_profile_selected called!")
	
	# checks if profile selected is valid
	if ! is_instance_valid(profile):
		printerr("Invalid profile selected")
		return
			
	# play "zooming in" animation before changing the view to the playground scene
	var tween = profile_selector_view.play_hide_buttons_animation()
	
	# Wait for 0.35 seconds before loading the profile 
	yield(profile_selector_view.get_tree().create_timer(0.35), "timeout")
	_master.load_profile(profile)
	
	# Wait for the animation to complete before hiding the profile select GUI
	yield(tween, "tween_all_completed")
	profile_selector_view.visible = false


func set_view(view):
	print("IN SET_VIEW")
	profile_selector_view = view
		# Setup the signal "profile_selected" to call "_on_profile_selected"
	profile_selector_view.connect("profile_selected", self, "_on_profile_selected")


func get_view():
	return profile_selector_view
