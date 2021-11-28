extends Node

class_name SketchesModel

var control_pane_t = preload("res://src/ui/sketch_control/ControlPane.tscn")

var sketch_manager: SketchManager = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
