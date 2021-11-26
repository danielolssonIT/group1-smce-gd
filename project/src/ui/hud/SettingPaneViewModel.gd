class_name SettingPaneViewModel

extends Node

signal profile_name_changed
signal update_boards_label
signal update_sketches_label
signal update_selected_world
signal update_save_btn_disabled

var unique_sketches: int = 0
var boards: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print("IN SETTING_PANE_VIEW_MODEL: READY")
	Signals.connect("profile_loaded", self, "reflect_profile")
	Signals.connect("active_profile_equals_orig_profile", self, "_signal_update_save_btn_disabled")
	Signals.connect("broadcast_active_profile", self, "reflect_profile")
	
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
	Signals.emit_signal("update_active_profile_name", name)

func save_profile() -> void:
	Signals.emit_signal("save_active_profile")

func load_world(world_name: String) -> void:
	print("IN SETTINGPANE: load_world")
	Signals.emit_signal("update_selected_world", world_name)
	Signals.emit_signal("load_active_profile")
	
func _signal_update_save_btn_disabled(is_disabled):
	emit_signal("update_save_btn_disabled", is_disabled)

