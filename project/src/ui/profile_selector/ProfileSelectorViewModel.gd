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
class_name ProfileSelectorViewModel

extends SignalerNode

signal hide_buttons
signal hide_profile_select

func _init():
	name = "ProfileSelectorViewModel"

func load_profile(profile) -> void:
	print("ProfileSelectorViewModel: on_profile_selected called!")
	
	# checks if profile selected is valid
	if ! is_instance_valid(profile):
		printerr("Invalid profile selected")
		return
			
	emit_signal("hide_buttons")
	
	# Wait for 0.35 seconds before loading the profile 
	yield(get_tree().create_timer(0.35), "timeout")
	channel.emit_signal("load_profile", profile)
	
	emit_signal("hide_profile_select")
	
func get_fresh_profile():
	return ObservableProfileConfig.new()
	
	
