class_name MasterModel

extends Signaler

var profile_manager = ObservableProfileManager.new()
#var sketch_manager = SketchManager.new() 

onready var world = get_node("/root/MasterView/World")

func _init():
	name = "MasterModel"
	profile_manager.load_profiles()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("IN MASTERMODEL: READY")
	profile_manager.connect("active_profile_changed", self, "assert_active_not_equals_orig")
	Signals.connect("read_active_profile", self, "broadcast_active_profile")
	Signals.connect("load_profile", profile_manager, "load_profile")
	
func get_child_signalers():
	return [profile_manager]
	
func broadcast_active_profile():
	Signals.emit_signal("broadcast_active_profile", profile_manager.active_profile)


func assert_active_not_equals_orig(active_profile = null):
	var is_equal = profile_manager.orig_profile.is_equal(profile_manager.active_profile)
	Signals.emit_signal("active_profile_equals_orig_profile", is_equal)
	
func set_selected_world(world_name: String) -> void:
	print("IN MASTERMODEL: set_selected_world")
	profile_manager.active_profile.environment = world_name
	
func set_active_profile_name(name):
	print("IN _ON_UPDATE_ACTIVE_PROFILE_NAME")	
	#var profile = profile_manager.active_profile
	#profile.profile_name = name
	profile_manager.active_profile.profile_name = name

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

