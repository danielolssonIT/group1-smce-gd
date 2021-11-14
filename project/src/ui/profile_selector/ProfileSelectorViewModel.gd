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

extends Node

var profile_manager = null

var profile_selector_view = null

func _init(view):
	profile_manager = Global.profile_manager
	profile_selector_view = view
	
	# Setup the signal "profile_selected" to call "_on_profile_selected"
	profile_selector_view.connect("profile_selected", self, "_on_profile_selected")	

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
	profile_manager.load_profile(profile)
	
	# Wait for the animation to complete before hiding the profile select GUI
	yield(tween, "tween_all_completed")
	profile_selector_view.visible = false
