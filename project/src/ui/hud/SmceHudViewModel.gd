extends Node

class_name SmceHudViewModel

#var sketch_select_t = preload("res://src/ui/sketch_select/SketchSelect.tscn")

signal update_hud
#signal show_left_pane

# Called when the node enters the scene tree for the first time.
func _init():
	Signals.connect("profile_loaded", self, "_on_profile_loaded")



func _on_profile_loaded(profile) -> void:
	print("IN SMCE_HUD_VIEW_MODEL: _ON_PROFILE_LOADED")
	emit_signal("update_hud", profile, profile.slots)

#
#func _on_sketch_btn() -> void:
#	control.get_focus_owner().release_focus()
#
#	emit_signal("show_left_pane", false)
#	#_set_vis(false) # EMIT SIGNAL INSTEAD
#
#	var sketch_select = sketch_select_t.instance()
#	sketch_select.init(model.sketch_manager)
#	get_tree().root.add_child(sketch_select)
#
#	var sketch = yield(sketch_select, "exited")
#
#	if ! is_instance_valid(sketch):
#		return
#
#	var pane = model._create_sketch_pane(sketch)
#
#	if pane == null:
#		return
#
#	var slot = _new_slot()
#	slot[1].grab_focus()
#	slot[1].pressed = true
#
#	_add_pane(pane, slot)
#
#
#func _on_toolchain_building(sketch, toolchain):
#	var notification = _create_notification("Compiling sketch '%s' ..." % sketch.get_source().get_file(), -1, true)
#
#	#maybe emit_signal?
#
#	toolchain.connect("built", self, "_on_toolchain_built", [toolchain, notification])
#
#
#func _on_toolchain_built(sketch, result, toolchain, notif):
#	notif.emit_signal("stop_notify")
#
#	toolchain.disconnect("built", self, "_on_toolchain_built")
#
#	if ! result.ok():
#		print("Compile failed: ", result.error())
#		_create_notification("Build failed for sketch '%s':\nReason: \"%s\"" % [sketch.get_source().get_file(), result.error()], 5)
#		#EMIT_SIGNAL?
#	else:
#		print("Compile finished succesfully")
#		_create_notification("Compile succeeded for sketch '%s'" % sketch.get_source().get_file(), 5)
#		#EMIT_SIGNAL?
#
#func _new_slot():
#	var activate_btn = button_t.instance()
#	var wrap = Control.new()
#
#	lpane.add_child(wrap)
#
#	activate_btn.connect("toggled", self, "_set_vis", [wrap])
#
#	buttons.append(activate_btn)
#	paths[activate_btn] = ""
#	activate_btn.group = button_group
#	button_group._init()
#	left_panel.add_child_below_node(attach, activate_btn)
#	attach = activate_btn
#
#	_reset_numbering()
#
#	_set_vis(false, wrap) 
#	set_disabled() 
#	return [wrap, activate_btn]

