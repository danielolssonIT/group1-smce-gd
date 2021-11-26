class_name MasterModel

extends Node

var profile_manager = Global.profile_manager
#var sketch_manager = SketchManager.new() 

onready var world = get_node("/root/Master/World")

func _init():
	profile_manager.load_profiles()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("IN MASTERMODEL: READY")
	
func set_selected_world(world_name: String) -> void:
	print("IN MASTERMODEL: set_selected_world")
	profile_manager.active_profile.environment = world_name
	
func update_active_profile_name(name):
	print("IN _ON_UPDATE_ACTIVE_PROFILE_NAME")	
	var profile = profile_manager.active_profile
	profile.profile_name = name

func save_active_profile() -> void:
	if profile_manager.saved_profiles.has(profile_manager.orig_profile):
		var path: String = profile_manager.saved_profiles[profile_manager.orig_profile]
		profile_manager.saved_profiles[profile_manager.active_profile] = path
		profile_manager.saved_profiles.erase(profile_manager.orig_profile)

	profile_manager.save_profile(profile_manager.active_profile)
	profile_manager.orig_profile = profile_manager.active_profile
	print("IN MASTERMODEL: _save_profile")
	profile_manager.active_profile = Util.duplicate_ref(profile_manager.active_profile)	

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

func load_active_profile():
	profile_manager.load_active_profile()
	
func get_profiles() -> Array:
	return profile_manager.saved_profiles.keys()

