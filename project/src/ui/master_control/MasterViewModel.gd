extends Node

class_name MasterViewModel

var master_view = null
var profile_manager = null

func _init(view):
	profile_manager = Global.profile_manager
	print("INIT MASTERVIEWMODEL: " + str(profile_manager))
	master_view = view
	
	profile_manager.load_profiles()
	profile_manager.connect("profile_loaded", self, "_on_profile_loaded")

# will enter this at start and every time we press "Reload" 
# since we technically first unload in order to be able to reload
# also every time we press "Switch" since we have to unload in order to switch profile
func leave_playground() -> void:
	yield(master_view.get_tree(), "idle_frame") # Resume execution the next frame
	if ! is_instance_valid(profile_manager.active_profile):
		return
	# Wait for the animation to finish before continuing in this function
	# but let the calling function/object continue its work.
	# The animation should play in parallel with other processes in the program.
	yield(master_view.fade_cover(true), "completed")
	
	#call on clear_view function in Master2.gd
	master_view.clear_view()
	

func load_world(profile: ProfileConfig) -> void:
	# Get the playground/environment that the car will drive in
	var env = Global.get_environment(profile.environment)
	if env == null:
		printerr("Invalid world: %s" % profile.environment)
		return
	
	# Load the world, print error if unsuccessful
	if ! yield(master_view.load_world(env), "completed"):
		printerr("Could not load world: %s" % profile.environment)
		return
		
#func setup_hud(profile: ProfileConfig) -> void:
	#master_view.setup_hud(profile.slots, profile) #call on func setup_hud in master2
	
# Don't know if this is needed anymore
# It was in Master.gd before but doesn't seem to have any real effect ever
# because the if cases are never executed
func _on_input(event: InputEvent) -> void:
	if is_instance_valid(profile_manager.active_profile):
		if event.is_action_pressed("reload"):
			profile_manager.load_active_profile()
		if event.is_action_pressed("ui_cancel"):
			master_view.show_profile_select()

func clear_profiles() -> void:
	yield(leave_playground(),"completed")
	yield(get_tree(), "idle_frame") # Wait for the next frame before continuing
	profile_manager.orig_profile = null
	print("IN MASTER: show_profile_select")
	profile_manager.active_profile = null
	
func load_orig_profile() -> void:
	profile_manager.load_orig_profile()
	
func get_profiles() -> Array:
	return profile_manager.saved_profiles.keys()
	
func _on_profile_loaded(profile):
	load_world(profile)
	#setup_hud(profile)
	master_view.fade_cover(false)
	
