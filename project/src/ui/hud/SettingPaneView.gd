class_name SettingPaneView

extends Node

signal toggled

onready var toggle_btn: Button = $VBoxContainer/MarginContainer2/Toggle

onready var profile_name_input: LineEdit = $VBoxContainer/MarginContainer2/ProfileName

onready var switch_btn: Button = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Switch
onready var reload_btn: Button = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Reload
onready var save_btn: Button = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Save

onready var world_list: OptionButton = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/Worlds
onready var sketches_label: Label = $VBoxContainer/MarginContainer/VBoxContainer/Sketches
onready var boards_label: Label = $VBoxContainer/MarginContainer/VBoxContainer/Boards

onready var version_label: Label = $VBoxContainer/MarginContainer/Version

var vm = SettingPaneViewModel.new() 
var channel = null setget set_channel

func _init():
	name = "SettingPaneView"

func _ready():
	add_child(vm, true)
	
	toggle_btn.connect("pressed", self, "emit_signal", ["toggled"])
	reload_btn.connect("pressed", self, "_reload_profile")
	switch_btn.connect("pressed", self, "_switch_profile")
	save_btn.connect("pressed", self, "_save_profile")
	profile_name_input.connect("text_changed", self, "_change_profile_name")
	world_list.connect("item_selected", self, "_on_world_selected")
	version_label.text = "SMCE-gd: %s" % Global.version
	
	vm.connect("profile_name_changed", self, "_on_profile_name_changed")
	vm.connect("update_boards_label", self, "_on_update_boards_label")
	vm.connect("update_sketches_label", self, "_on_update_sketches_label")
	vm.connect("update_selected_world", self, "_on_update_selected_world")
	vm.connect("update_save_btn_disabled", self, "_on_update_save_btn_disabled")
	
	#vm.reflect_profile()
	
	_update_envs()

func set_channel(_channel):	
	channel = _channel
	
	for child in [vm]:
		child.channel = _channel
		
	yield(get_tree(), "idle_frame")
	channel.emit_signal("read_active_profile")

func _save_profile():
	vm.save_profile()

func _update_envs():
	for env in Global.environments.keys():
		world_list.add_item(env)

func _switch_profile() -> void:
	channel.emit_signal("show_profile_select")


func _reload_profile() -> void:
	channel.emit_signal("reload_profile")
	
func _change_profile_name(text: String):
	vm.update_active_profile_name(text)

# ------------------
# SETTERS
# ------------------
func _set_profile_name(name: String) -> void:
	if profile_name_input.text != name:
		profile_name_input.text = name

func _set_number_of_boards(count) -> void:
	boards_label.text = "Boards: %d" % count

func _set_number_of_sketches(count) -> void:
	sketches_label.text = "Sketches: %d" % count

func _set_selected_world(world_index: int) -> void:
	world_list.select(world_index)

func _set_save_btn_disabled(disabled: bool) -> void:
	save_btn.disabled = disabled
	
# ------------------
# SIGNAL HANDLERS
# ------------------
func _on_world_selected(index: int) -> void:
	print("IN SETTINGPANE: _on_world_selected")
	vm.load_world(world_list.get_item_text(index))

func _on_profile_name_changed(name) -> void:
	_set_profile_name(name)

func _on_update_boards_label(number_of_boards: int) -> void:
	_set_number_of_boards(number_of_boards)

func _on_update_sketches_label(number_of_sketches: int) -> void:
	_set_number_of_sketches(number_of_sketches)

func _on_update_selected_world(world_index: int) -> void:
	_set_selected_world(world_index)

func _on_update_save_btn_disabled(disabled: bool) -> void:
	_set_save_btn_disabled(disabled)
