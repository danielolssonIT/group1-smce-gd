extends Node

class_name SmceHudViewModel2

signal add_control_to_lpane
signal add_button_to_lpane
signal reset_numbering
signal set_node_visible
signal set_buttons_disabled
signal add_pane


var sketch_select_t = preload("res://src/ui/sketch_select/SketchSelect.tscn")
var control_pane_t = preload("res://src/ui/sketch_control/ControlPane.tscn")
var button_t = preload("res://src/ui/hud/SketchButton.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var sketch_manager = null
var buttons: Array = []
var paths: Dictionary = {}
var button_group: BButtonGroup = BButtonGroup.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _init(sketch_manager, buttons, paths, button_group):
	self.sketch_manager = sketch_manager
	self.buttons = buttons
	self.paths = paths
	self.button_group = button_group
	

func sketch_button_clicked() -> void:
	var sketch_select = sketch_select_t.instance()
	sketch_select.init(sketch_manager)
	get_tree().root.add_child(sketch_select)
		
	var sketch = yield(sketch_select, "exited")
	
	if ! is_instance_valid(sketch):
		return
	
	var pane = _create_sketch_pane(sketch)
	
	if pane == null:
		return
	
	var slot = _new_slot()
	slot[1].grab_focus()
	slot[1].pressed = true
	
	emit_signal("add_pane", pane, slot)


func _create_sketch_pane(sketch):
	
	var pane = control_pane_t.instance()
	var toolchain = sketch_manager.get_toolchain(sketch)
	
	if ! toolchain.is_connected("building", self, "_on_toolchain_building"):
		toolchain.connect("building", self, "_on_toolchain_building", [toolchain])
	
	var res = pane.init(sketch, toolchain)
	
	if ! res.ok():
		printerr("Failed to make control pane: ", res.error())
		return null
	
	return pane


func _new_slot():
	var activate_btn = button_t.instance()
	var wrap = Control.new()

	#lpane.add_child(wrap)
	emit_signal("add_control_to_lpane", wrap)

	activate_btn.connect("toggled", self, "_set_vis", [wrap])

	buttons.append(activate_btn)
	paths[activate_btn] = ""
	activate_btn.group = button_group
	button_group._init()
	#left_panel.add_child_below_node(attach, activate_btn)
	emit_signal("add_button_to_lpane", activate_btn)
	
	#attach = activate_btn
	
	#_reset_numbering()
	emit_signal("reset_numbering")
	#_set_vis(false, wrap) 
	emit_signal("set_node_visible", false, wrap)
	#set_disabled()
	emit_signal("set_buttons_disabled") 
	return [wrap, activate_btn]




