#
#  Master.gd
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

var hud_t = preload("res://src/ui/hud/SmceHud.tscn")

onready var world = $World
onready var profile_select = $ProfileSelect
onready var hud_attach = $HUD
onready var hud = null
onready var screen_cover = $ScreenCover

onready var sketch_manager = $SketchManager

signal unload_profile_completed

var vm = null

func _ready() -> void:
	vm = MasterViewModel.new(self) #MasterViewModel variable created
	show_profile_select()

# handles inputEvents
func _input(event: InputEvent):
	if event.is_action_pressed("ui_home"):
		print_stray_nodes()
	vm._on_input(event)

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
	# Play "zooming out" animation before showing the profile select GUI
	yield(vm.leave_playground(), "completed")
	profile_select.play_show_buttons_animation(vm.get_profiles())

# reloads profile when "Reload" is pressed
func reload_profile() -> void:
	#leave playground in order to load profile again
	yield(vm.leave_playground(),"completed")
	vm.load_orig_profile()

###### NEW ADDED FUNCTIONS ################
func clear_view() -> void:
	if is_instance_valid(hud):
		hud.queue_free()
	world.clear_world()

func load_world(env) -> void:
	yield(get_tree(), "idle_frame")
	world.load_world(env)

func _on_load_world(profile: ProfileConfig) -> void:
	# Get the playground/environment that the car will drive in
	var env = Global.get_environment(profile.environment)
	if env == null:
		printerr("Invalid world: %s" % profile.environment)
		return
	
	# Load the world, print error if unsuccessful
	if ! yield(world.load_world(env), "completed"):
		printerr("Could not load world: %s" % profile.environment)
		return
	
func setup_hud(slots: Array, active_profile) -> void:
	# SETUP all the resources every time a profile has been loaded 
	# and apply them into the SmceHud variables
	hud = hud_t.instance() # Apply the SmceHud menu when a profile has been loaded
	hud.cam_ctl = world.cam_ctl
	print("MASTER: HUD PROFILE")
	# FIX IN FUTURE WHEN REFACTORING SMCE HUD
	hud.profile = active_profile
	hud.sketch_manager = sketch_manager
	hud.master_manager = self
	hud_attach.add_child(hud)
	hud.add_slots(slots)
