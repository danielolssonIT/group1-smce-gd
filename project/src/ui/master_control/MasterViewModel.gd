extends Node

class_name MasterViewModel

signal clear_view
signal show_playground
signal leave_playground

var model = null

func _init():
	model = MasterModel.new()
	model.profile_manager.connect("profile_loaded", self, "_on_profile_loaded")
	add_child(model)

func _ready():
	pass
	#add_child(model.world, true)

# will enter this at start and every time we press "Reload" 
# since we technically first unload in order to be able to reload
# also every time we press "Switch" since we have to unload in order to switch profile
func leave_playground() -> void:
	yield(get_tree(), "idle_frame") # Resume execution the next frame

	model.clear_world()

func clear_profiles() -> void:
	yield(leave_playground(),"completed")
	yield(get_tree(), "idle_frame") # Wait for the next frame before continuing
	model.clear_profiles()
	
func reload_profile():
	yield(leave_playground(),"completed")
	model.load_orig_profile()
	
func get_profiles() -> Array:
	return model.get_profiles()
	
func _on_profile_loaded(profile):
	model.load_world(profile)
	emit_signal("show_playground")
