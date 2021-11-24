class_name SettingPaneViewModel

extends Node


signal profile_name_changed
signal update_boards_label
signal update_sketches_label
signal update_selected_world
signal update_save_btn_disabled

var profile_manager = Global.profile_manager

var unique_sketches: int = 0
var boards: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	profile_manager.connect("profile_loaded", self, "_on_profile_loaded")
	profile_manager.connect("active_profile_changed", self, "_on_active_profile_changed")

func _on_profile_loaded(profile) -> void:
	reflect_profile(profile)
	
	
func reflect_profile(profile = profile_manager.active_profile):
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
	var profile = profile_manager.active_profile
	profile.profile_name = name

func save_profile() -> void:
	if profile_manager.saved_profiles.has(profile_manager.orig_profile):
		var path: String = profile_manager.saved_profiles[profile_manager.orig_profile]
		profile_manager.saved_profiles[profile_manager.active_profile] = path
		profile_manager.saved_profiles.erase(profile_manager.orig_profile)

	profile_manager.save_profile(profile_manager.active_profile)
	profile_manager.orig_profile = profile_manager.active_profile
	profile_manager.active_profile = Util.duplicate_ref(profile_manager.active_profile)

func load_world(world_name: String) -> void:
	print("IN SETTINGPANE: load_world")
	profile_manager.active_profile.environment = world_name
	profile_manager.load_profile(profile_manager.active_profile)

func _change_profile_name(text: String) -> void:
	print("IN SETTINGPANE: _change_profile_name")
	profile_manager.active_profile.profile_name = text

func _on_active_profile_changed(active_profile):
	_signal_update_save_btn_disabled()
	
	
func _signal_update_save_btn_disabled():
	if profile_manager.orig_profile.is_equal(profile_manager.active_profile):
		emit_signal("update_save_btn_disabled", true)
	else:
		emit_signal("update_save_btn_disabled", false)

