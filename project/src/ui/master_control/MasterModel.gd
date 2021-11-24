class_name MasterModel

extends Node

var profile_manager = Global.profile_manager
#var sketch_manager = SketchManager.new() 

onready var world = get_node("/root/Master/World")

func _init():
	profile_manager.load_profiles()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func clear_world():
	world.clear_world()
	
func clear_profiles():
	profile_manager.orig_profile = null
	profile_manager.active_profile = null
	
func load_world(profile):
	# Get the playground/environment that the car will drive in
	var env = Global.get_environment(profile.environment)
	if env == null:
		printerr("Invalid world: %s" % profile.environment)
		return
	
	# Load the world, print error if unsuccessful
	if ! yield(world.load_world(env), "completed"):
		printerr("Could not load world: %s" % profile.environment)
		return

func load_orig_profile():
	profile_manager.load_orig_profile()
	
func get_profiles() -> Array:
	return profile_manager.saved_profiles.keys()
