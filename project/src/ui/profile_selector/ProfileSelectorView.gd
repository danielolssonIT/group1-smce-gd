#
#  ProfileSelector.gd
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
class_name ProfileSelectorView

extends Signaler

var profile_button_t = preload("res://src/ui/profile_selector/ProfileButton.tscn")

onready var attach = $VBoxContainer/CenterContainer/MarginContainer/HBoxContainer
onready var fresh_btn = attach.get_node("Button") # "Start Fresh" button

var vm = null # the view model for profile selection

# Make sure "_on_profile_pressed" is called when button is pressed
func _ready() -> void:
	print("IN PROFILE_SELECTOR_VIEW _READY()")
	vm = ProfileSelectorViewModel.new()
	
	add_child(vm, true)
	
	fresh_btn.connect("pressed", self, "_on_profile_pressed", [vm.get_fresh_profile()])
	vm.connect("hide_buttons", self, "_on_hide_buttons")
	vm.connect("hide_profile_select", self, "_on_hide_profile_select")
	
func get_child_signalers():
	return []	

# displays saved profiles horizontally on the start page
func display_profiles(arr: Array) -> void:
	# removes all saved profile buttons 
	for child in attach.get_children():
		if child != fresh_btn:
			child.queue_free()
	# add profile button for each saved profile
	for profile in arr:
		var btn = profile_button_t.instance()
		attach.add_child(btn)
		btn.display_profile(profile)
		btn.connect("pressed", self, "_on_profile_pressed", [profile])
		
# play "zooming in" animation for hiding buttons to enter the playground
func play_hide_buttons_animation() -> Tween:
	var tween: Tween = TempTween.new()
	add_child(tween)
	self.rect_pivot_offset = self.rect_size / 2	
	tween.interpolate_property(self, "modulate:a", 1, 0, 0.4, Tween.TRANS_CUBIC)
	tween.interpolate_property(self, "rect_scale", Vector2(1,1), Vector2(10,10), 0.4, Tween.TRANS_CUBIC)
	tween.start()
	return tween

# Play "zooming out" animation (before showing the profile select GUI)
func play_show_buttons_animation(profiles: Array) -> void: 
	var tween: Tween = TempTween.new()
	add_child(tween)
	self.display_profiles(profiles)
	self.visible = true
	self.rect_pivot_offset = self.rect_size / 2
	tween.interpolate_property(self, "modulate:a", 0, 1, 0.4, Tween.TRANS_CUBIC)
	tween.interpolate_property(self, "rect_scale", Vector2(10,10), Vector2(1,1), 0.4, Tween.TRANS_CUBIC)
	tween.start()

# send signal to master.gd when profile is selected
func _on_profile_pressed(profile) -> void:
	vm.load_profile(profile)

func _on_hide_buttons() -> void:
	play_hide_buttons_animation()

func _on_hide_profile_select() -> void:
	self.visible = false
