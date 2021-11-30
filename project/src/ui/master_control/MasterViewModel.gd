extends Node

class_name MasterViewModel

signal clear_view
signal show_playground
signal leave_playground
signal reload_profile

var model = MasterModel.new()
var channel = null setget set_channel

func _init():
	name = "MasterViewModel"
	
func _ready():
	add_child(model, true)

func set_channel(_channel):	
	channel = _channel
	
	channel.connect("profile_loaded", self, "_on_profile_loaded")
	channel.connect("save_active_profile", model, "save_active_profile")
	channel.connect("update_active_profile_name" , model, "set_active_profile_name")
	channel.connect("update_selected_world", model, "set_selected_world")
	channel.connect("load_active_profile", model, "load_active_profile")
	channel.connect("show_profile_select", self, "emit_signal", ["leave_playground"])
	channel.connect("reload_profile", self, "emit_signal", ["reload_profile"])
	
	for child in [model]:
		child.set_channel(_channel)

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
