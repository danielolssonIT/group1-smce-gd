#
#  MasterView.gd
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

extends Signaler

onready var profile_select = $ProfileSelect
onready var screen_cover = $ScreenCover
onready var hud = $HUD

var vm = null

func _ready() -> void:
	name = "MasterView"
	vm = MasterViewModel.new() #MasterViewModel variable created
	add_child(vm, true)
	
	profile_select.play_show_buttons_animation(vm.get_profiles())

	vm.connect("show_playground", self, "_on_show_playground")
	vm.connect("leave_playground", self, "_on_leave_playground")
	vm.connect("reload_profile", self, "reload_profile")
	
	set_signals_handler(Signals2.new())
	print("MASTER_VIEW _READY() DONE!")
	
func get_child_signalers():
	return [profile_select, vm]
	
# handles inputEvents
func _input(event: InputEvent):
	if event.is_action_pressed("ui_home"):
		print_stray_nodes()
	if event.is_action_pressed("reload"):
		reload_profile()
	if event.is_action_pressed("ui_cancel"):
		show_profile_select()
	
# Fade in/out the screen cover (the background in the profile selector view)
func fade_cover(show_screen_cover: bool):
	var tween: Tween = TempTween.new()
	add_child(tween)
	
	# Wait for the fade out animation to complete before hiding the screen cover
	if show_screen_cover:
		screen_cover.visible = show_screen_cover
	
	# Play fade in/out
	if show_screen_cover: # Make screen cover appear
		tween.interpolate_property(screen_cover, "modulate:a", 0, 1, 0.4, Tween.TRANS_CUBIC)
	else: # Make screen cover disappear
		tween.interpolate_property(screen_cover, "modulate:a", 1, 0, 0.4, Tween.TRANS_CUBIC)
		
	tween.start()
	
	yield(tween,"tween_all_completed") # Wait for animation to finish
	
	# If screen cover is visible, the player cannot control the camera
	screen_cover.visible = show_screen_cover

# Display the GUI for selecting profiles (the first screen the user sees when opening the program)
# Should contain a "Start Fresh"-button, and a button for each saved profile.
func show_profile_select() -> void:
	yield(fade_cover(true), "completed")
	# Play "zooming out" animation before showing the profile select GUI
	yield(vm.leave_playground(), "completed")
	profile_select.play_show_buttons_animation(vm.get_profiles())

# reloads profile when "Reload" is pressed
func reload_profile() -> void:
	yield(fade_cover(true), "completed")
	
	#leave playground in order to load profile again
	vm.reload_profile()
	
func _on_show_playground() -> void:
	yield(fade_cover(false), "completed")
	
func _on_leave_playground() -> void:
	show_profile_select()
	
