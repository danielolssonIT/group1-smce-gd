extends Node

class_name MasterViewModel

signal clear_view
signal show_playground
signal leave_playground

var world_t = preload("res://src/ui/master_control/World.tscn")
var world = null

var profile_manager = null


func _init():
	profile_manager = Global.profile_manager
	print("INIT MASTERVIEWMODEL: " + str(profile_manager))
	
	profile_manager.load_profiles()
	profile_manager.connect("profile_loaded", self, "_on_profile_loaded")

func _ready():
	world = world_t.instance()
	get_parent().add_child(world)

# will enter this at start and every time we press "Reload" 
# since we technically first unload in order to be able to reload
# also every time we press "Switch" since we have to unload in order to switch profile
func leave_playground() -> void:
	yield(get_tree(), "idle_frame") # Resume execution the next frame
	if ! is_instance_valid(profile_manager.active_profile):
		return

	world.clear_world()

func load_world(profile) -> void:
	# Get the playground/environment that the car will drive in
	var env = Global.get_environment(profile.environment)
	if env == null:
		printerr("Invalid world: %s" % profile.environment)
		return
	
	# Load the world, print error if unsuccessful
	if ! yield(world.load_world(env), "completed"):
		printerr("Could not load world: %s" % profile.environment)
		return
		

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
	emit_signal("show_playground")
	
	
