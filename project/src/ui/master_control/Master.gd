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

var orig_profile: ProfileConfig = null
var active_profile: ProfileConfig = null

# sends signal "profile_selected" to method _on_profile_sel
func _ready() -> void:
	profile_select.connect("profile_selected", self, "_on_profile_selected")
	
	profile_manager.load_profiles()
	
	show_profile_select()


func _input(event: InputEvent):
	if event.is_action_pressed("ui_home"):
		print_stray_nodes()
	if is_instance_valid(active_profile):
		if event.is_action_pressed("reload"):
			load_profile(active_profile)
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
		tween.interpolate_property(screen_cover, "modulate:a", 0, 1, 2.3, Tween.TRANS_CUBIC)
	else: # Make screen cover disappear
		tween.interpolate_property(screen_cover, "modulate:a", 1, 0, 2.3, Tween.TRANS_CUBIC)
		
	tween.start()
	
	yield(tween,"tween_all_completed") # Wait for animation to finish
	
	# If screen cover is visible, the player cannot control the camera
	screen_cover.visible = show_screen_cover

# Display the GUI for selecting profiles (the first screen the user sees when opening the program)
# Should contain a "Start Fresh"-button, and a button for each saved profile.
func show_profile_select() -> void:
	yield(unload_profile(),"completed")
	yield(get_tree(), "idle_frame") # Wait for the next frame before continuing
	orig_profile = null
	active_profile = null
	
	# Play "zooming out" animation before showing the profile select GUI
	var tween: Tween = TempTween.new()
	add_child(tween)
	profile_select.display_profiles(profile_manager.saved_profiles.keys())
	profile_select.visible = true
	profile_select.rect_pivot_offset = profile_select.rect_size / 2
	tween.interpolate_property(profile_select, "modulate:a", 0, 1, 0.4, Tween.TRANS_CUBIC)
	tween.interpolate_property(profile_select, "rect_scale", Vector2(10,10), Vector2(1,1), 0.4, Tween.TRANS_CUBIC)
	tween.start()


func _on_profile_selected(profile: ProfileConfig) -> void:
	# checks if profile selected is valid
	if ! is_instance_valid(profile):
		printerr("Invalid profile selected")
		return
	
	# play "zooming in" animation before changing the view to the playground scene
	var tween: Tween = TempTween.new()
	add_child(tween)
	profile_select.rect_pivot_offset = profile_select.rect_size / 2	
	tween.interpolate_property(profile_select, "modulate:a", 1, 0, 0.4, Tween.TRANS_CUBIC)
	tween.interpolate_property(profile_select, "rect_scale", Vector2(1,1), Vector2(10,10), 0.4, Tween.TRANS_CUBIC)
	tween.start()
	
	# Wait for 0.35 seconds before loading the profile 
	yield(get_tree().create_timer(0.35), "timeout")
	load_profile(profile)
	
	# Wait for the animation to complete before hiding the profile select GUI
	yield(tween, "tween_all_completed")
	profile_select.visible = false


func reload_profile() -> void:
	load_profile(orig_profile)


func unload_profile() -> void:
	yield(get_tree(), "idle_frame") # Resume execution the next frame
	if ! is_instance_valid(active_profile):
		return
	
	# Wait for the animation to finish before continuing in this function
	# but let the calling function/object continue its work.
	# The animation should play in parallel with other processes in the program.
	yield(fade_cover(true), "completed")

	if is_instance_valid(hud):
		hud.queue_free()
	world.clear_world()


func load_profile(profile: ProfileConfig) -> void:
	if ! is_instance_valid(profile):
		return
	
	# Start unloading the current active profile, wait until finished
	if is_instance_valid(active_profile):
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
	
	# If we switch to another profile, 
	if active_profile != profile:
		orig_profile = profile
		active_profile = Util.duplicate_ref(profile)
	
	
	hud = hud_t.instance()
	hud.cam_ctl = world.cam_ctl
	hud.profile = active_profile
	hud.sketch_manager = sketch_manager
	hud.master_manager = self
	hud_attach.add_child(hud)
	
	hud.add_slots(profile.slots)
	
	fade_cover(false)

