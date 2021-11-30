class_name SettingPaneViewModel

extends SignalerNode

signal profile_name_changed
signal update_boards_label
signal update_sketches_label
signal update_selected_world
signal update_save_btn_disabled

var unique_sketches: int = 0
var boards: Array = []

func _init():
	name = "SettingPaneViewModel"
	
func on_channel_set():
	channel.connect("profile_loaded", self, "reflect_profile")
	channel.connect("active_profile_equals_orig_profile", self, "_signal_update_save_btn_disabled")
	channel.connect("broadcast_active_profile", self, "reflect_profile")
	
func reflect_profile(profile):
	if ! is_instance_valid(profile):
		return
	
	var pname = profile.profile_name
	emit_signal("profile_name_changed", pname)
	
	emit_signal("update_boards_label", profile.slots.size())
	
	# Count the number of unique sketches in the profile
	var map: Dictionary = {}
	for slot in profile.slots:
		map[slot.path] = null
	
	emit_signal("update_sketches_label", map.size())
	
	var world_index = Global.environments.keys().find(profile.environment)
	emit_signal("update_selected_world", world_index)
	
func update_active_profile_name(name: String) -> void:
	channel.emit_signal("update_active_profile_name", name)

func save_profile() -> void:
	channel.emit_signal("save_active_profile")

func load_world(world_name: String) -> void:
	print("IN SETTINGPANE: load_world")
	channel.emit_signal("update_selected_world", world_name)
	channel.emit_signal("load_active_profile")
	
func _signal_update_save_btn_disabled(is_disabled):
	emit_signal("update_save_btn_disabled", is_disabled)

