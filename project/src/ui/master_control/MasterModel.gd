class_name MasterModel

extends Node

var profile_manager = Global.profile_manager
#var sketch_manager = SketchManager.new() 
#var world = World.new()

var world_t = preload("res://src/ui/master_control/World.tscn")
var world = null

func _init():
	world = world_t.instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func clear_world():
	world.clear_world()
	
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
