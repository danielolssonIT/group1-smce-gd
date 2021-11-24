extends Node

class_name MasterViewModel

signal clear_view
signal show_playground
signal leave_playground

#var world_t = preload("res://src/ui/master_control/World.tscn")
#var world = null

var profile_manager = null

var model = MasterModel.new()

func _init():
	profile_manager = Global.profile_manager
	print("INIT MASTERVIEWMODEL: " + str(profile_manager))
	
	profile_manager.load_profiles()
	profile_manager.connect("profile_loaded", self, "_on_profile_loaded")

func _ready():
	#get_parent().add_child(world)
	add_child(model.world, true)

# will enter this at start and every time we press "Reload" 
# since we technically first unload in order to be able to reload
# also every time we press "Switch" since we have to unload in order to switch profile
func leave_playground() -> void:
	yield(get_tree(), "idle_frame") # Resume execution the next frame
	if ! is_instance_valid(profile_manager.active_profile):
		return

	model.clear_world()

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
	model.load_world(profile)
	emit_signal("show_playground")
	
	
