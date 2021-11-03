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

var profile_manager = ProfileManager.new()
onready var sketch_manager = $SketchManager

var orig_profile: ProfileConfig = null setget set_orig_profile, get_orig_profile
var active_profile: ProfileConfig = null setget set_active_profile, get_active_profile

func _ready() -> void:
	profile_manager.load_profiles()
	show_profile_select()

# handles inputEvents
func _input(event: InputEvent):
	if event.is_action_pressed("ui_home"):
		print_stray_nodes()
	if is_instance_valid(profile_manager.active_profile):
		if event.is_action_pressed("reload"):
			load_profile(profile_manager.active_profile)
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
		tween.interpolate_property(screen_cover, "modulate:a", 0, 1, 0.3, Tween.TRANS_CUBIC)
	else: # Make screen cover disappear
		tween.interpolate_property(screen_cover, "modulate:a", 1, 0, 0.3, Tween.TRANS_CUBIC)
		
	tween.start()
	
	yield(tween,"tween_all_completed") # Wait for animation to finish
	
	# If screen cover is visible, the player cannot control the camera
	screen_cover.visible = show_screen_cover

# Display the GUI for selecting profiles (the first screen the user sees when opening the program)
# Should contain a "Start Fresh"-button, and a button for each saved profile.
func show_profile_select() -> void:
	yield(unload_profile(),"completed")
	yield(get_tree(), "idle_frame") # Wait for the next frame before continuing
	profile_manager.orig_profile = null
	profile_manager.active_profile = null
	
	# Play "zooming out" animation before showing the profile select GUI
	profile_select.play_show_buttons_animation()

# reloads profile when "Reload" is pressed
func reload_profile() -> void:
	load_profile(profile_manager.orig_profile)

# will enter this at start and every time we press "Reload" 
# since we technically first unload in order to be able to reload
# also every time we press "Switch" since we have to unload in order to switch profile
func unload_profile() -> void:
	yield(get_tree(), "idle_frame") # Resume execution the next frame
	if ! is_instance_valid(profile_manager.active_profile):
		return
	
	# Wait for the animation to finish before continuing in this function
	# but let the calling function/object continue its work.
	# The animation should play in parallel with other processes in the program.
	yield(fade_cover(true), "completed")

	if is_instance_valid(hud):
		hud.queue_free()
	world.clear_world()

# handles the progression when loading the profile that has been selected to be able to start the game
func load_profile(profile: ProfileConfig) -> void:
	if ! is_instance_valid(profile):
		return
	
	# Start unloading the current active profile when "Reload" has been pressed, wait until finished
	if is_instance_valid(profile_manager.active_profile):
		yield(unload_profile(), "completed")
	
	# Get the playground/environment that the car will drive in
	var env = Global.get_environment(profile.environment)
	if env == null:
		printerr("Invalid world: %s" % profile.environment)
		return
	
	# Load the world, print error if unsuccessful
	if ! yield(world.load_world(env), "completed"):
		printerr("Could not load world: %s" % profile.environment)
		return
	
	# If we switch to another profile, (either pressing "start fresh" or on a saved profile)
	if profile_manager.active_profile != profile:
		profile_manager.orig_profile = profile
		profile_manager.active_profile = Util.duplicate_ref(profile)
	
	# SETUP all the resources every time a profile has been loaded 
	# and apply them into the SmceHud variables
	hud = hud_t.instance() # Apply the SmceHud menu when a profile has been loaded
	hud.cam_ctl = world.cam_ctl
	hud.profile = profile_manager.active_profile
	hud.sketch_manager = sketch_manager
	hud.master_manager = self
	hud_attach.add_child(hud)
	hud.add_slots(profile.slots)
	
	#profile has been succesfully loaded and we stop the fading
	fade_cover(false)

# set the orig profile(name of profile) only enters here when we save a profile
func set_orig_profile(new_val: ProfileConfig) -> void:
	print("Master - Setting original profile to: " + new_val.profile_name)
	profile_manager.orig_profile = new_val

# return orig profile
func get_orig_profile() -> ProfileConfig:
	return profile_manager.orig_profile

# set the active profile(name of profile)
func set_active_profile(new_val: ProfileConfig) -> void:
	print("Master - Setting active profile to: " + new_val.profile_name)
	profile_manager.active_profile = new_val

# get the active profile	
func get_active_profile() -> ProfileConfig:
	return profile_manager.active_profile
