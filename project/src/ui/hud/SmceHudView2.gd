#
#  SmceHud.gd
#  Copyright 2021 ItJustWorksTM
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

class_name SmceHudView2
extends Control

var button_t = preload("res://src/ui/hud/SketchButton.tscn")
var control_pane_t = preload("res://src/ui/sketch_control/ControlPane.tscn")
var sketch_select_t = preload("res://src/ui/sketch_select/SketchSelect.tscn")
var notification_t = preload("res://src/ui/simple_notification/SimpleNotification.tscn")

onready var lpane = $LeftPane
onready var left_panel = $Panel/VBoxContainer/ScrollContainer/VBoxContainer
onready var attach = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/Control
onready var new_sketch_btn = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/ToolButton
onready var notification_display = $Notifications

onready var profile_control = $ProfileControl
onready var profile_control_toggle = $Panel/VBoxContainer/MarginContainer/VBoxContainer/ProfileControlToggle
onready var profile_screen_toggle = $ProfileScreentoggle

var button_group: BButtonGroup = BButtonGroup.new()


var buttons: Array = []
var paths: Dictionary = {}

var cam_ctl: CamCtl = null
var profile = null
var sketch_manager: SketchManager = null

var disabled = false setget set_disabled

var vm = null

# VIEW (added)
func set_disabled(val: bool = disabled) -> void:
	disabled = val
	for btn in buttons:
		btn.disabled = val
	if is_instance_valid(new_sketch_btn):
		new_sketch_btn.disabled = val


func _ready() -> void:
	print("IN SMCEHUD2VIEW")
	set_disabled()
	button_group._init()
	new_sketch_btn.connect("pressed", self, "_on_sketch_btn")
	profile_control.connect("toggled", self, "_toggle_profile_control", [false])
	profile_control_toggle.connect("pressed", self, "_toggle_profile_control", [true])
	profile_screen_toggle.connect("button_down", self, "_toggle_profile_control", [false])

	sketch_manager = SketchManager.new()
	
	vm = SmceHudViewModel2.new(sketch_manager, buttons, paths, button_group) 
	add_child(vm,true)
	
	
	vm.connect("add_control_to_lpane", self, "_on_add_control_to_lpane")
	vm.connect("add_button_to_lpane", self , "_on_add_button_to_lpane")
	vm.connect("reset_numbering", self, "_on_reset_numbering")
	vm.connect("set_node_visible", self, "_on_set_node_visible")
	vm.connect("set_buttons_disabled", self, "_on_set_buttons_disabled")
	vm.connect("add_pane", self, "_on_add_pane")
	
func _on_add_pane(pane, slot):
	_add_pane(pane, slot)

func _on_set_buttons_disabled():
	set_disabled()

func _on_set_node_visible(false, node):
	_set_vis(false, node)

func _on_reset_numbering():
	_reset_numbering()

func _on_add_control_to_lpane(control):
	lpane.add_child(control)

func _on_add_button_to_lpane(btn):
	left_panel.add_child_below_node(attach, btn)
	attach = btn
	
# VIEW
func _toggle_profile_control(show: bool) -> void:
	var tween: Tween = TempTween.new()
	add_child(tween)
	
	profile_screen_toggle.visible = show
	tween.interpolate_property(profile_control, "rect_position:x", profile_control.rect_position.x,  -int(!show) * (profile_control.rect_size.x) + int(!show) * -8, 0.25,Tween.TRANS_CUBIC)
	
	tween.start()

# VIEW
func _set_vis(visible, node = null) -> void:
	var tween: Tween = TempTween.new()
	add_child(tween)
	
	tween.interpolate_property(lpane, "rect_position:x", lpane.rect_position.x,  -int(!visible) * (lpane.rect_size.x) + int(visible) * 48, 0.25,Tween.TRANS_CUBIC)

	if is_instance_valid(node):
		tween.interpolate_property(node, "modulate:a", node.modulate.a, int(visible), 0.2)
		tween.interpolate_property(node, "visible", node.visible, visible, 0.2)
	
	tween.start()

# VIEWMODEL
func _on_sketch_btn() -> void:
	get_focus_owner().release_focus()
	
	_set_vis(false)

	vm.sketch_button_clicked()


# VIEWMODEL , MODEL(added)
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

# VIEWMODEL(added) , MODEL
func _on_toolchain_building(sketch, toolchain):
	var notification = _create_notification("Compiling sketch '%s' ..." % sketch.get_source().get_file(), -1, true)
	
	toolchain.connect("built", self, "_on_toolchain_built", [toolchain, notification])

# VIEWMODEL(added) , MODEL
func _on_toolchain_built(sketch, result, toolchain, notif):
	notif.emit_signal("stop_notify")
	
	toolchain.disconnect("built", self, "_on_toolchain_built")
	
	if ! result.ok():
		print("Compile failed: ", result.error())
		_create_notification("Build failed for sketch '%s':\nReason: \"%s\"" % [sketch.get_source().get_file(), result.error()], 5)
	else:
		print("Compile finished succesfully")
		_create_notification("Compile succeeded for sketch '%s'" % sketch.get_source().get_file(), 5)

# VIEWMODEL(added)
func _new_slot():
	var activate_btn = button_t.instance()
	var wrap = Control.new()

	lpane.add_child(wrap)

	activate_btn.connect("toggled", self, "_set_vis", [wrap])

	buttons.append(activate_btn)
	paths[activate_btn] = ""
	activate_btn.group = button_group
	button_group._init()
	left_panel.add_child_below_node(attach, activate_btn)
	attach = activate_btn
	
	_reset_numbering()
	
	_set_vis(false, wrap) 
	set_disabled() 
	return [wrap, activate_btn]

#VIEW
func _add_pane(pane: Control, slot):
	pane.connect("grab_focus", slot[1], "set", ["pressed", true])
	pane.connect("notification_created", notification_display, "add_notification")
	
	# cursed..
	pane.connect("tree_exited", self, "_remove_pane", slot)
	connect("tree_exiting", pane, "disconnect", ["tree_exited", self, "_remove_pane"])
	
	pane.set_cam_ctl(cam_ctl)
	paths[slot[1]] = pane.sketch_path
	slot[0].add_child(pane)
	_set_vis(slot[1].pressed, slot[0])
	
	profile.slots = slots()
	#Global.profile_manager.active_profile.slots = slots()

#VIEW
func _remove_pane(node, button) -> void:
	print("IN REMOVE_PANE")
	buttons.erase(button)
	paths.erase(button)
	button.queue_free()
	node.queue_free()
	_reset_numbering()
	_set_vis(false)

# VIEW
func _create_notification(text: String, timeout: float = -1, progress: bool = false, button: bool = false) -> Control:
	var notification: Control = notification_t.instance().setup(self, text, timeout, progress, button)
	notification_display.add_notification(notification, timeout)
	
	notification.connect("pressed", self, "emit_signal", ["grab_focus"])
	
	return notification

#VIEW
func _reset_numbering() -> void:
	for i in range(buttons.size()):
		buttons[i].text = str(i + 1)
	attach = buttons.back() if !buttons.empty() else $Panel/VBoxContainer/ScrollContainer/VBoxContainer/Control


class Slot:
	var pos: int = 0
	var path: String = ""
	
	static func comp(a, b) -> bool:
		return a.pos < b.pos
	
	func is_equal(b) -> bool:
		return b.pos == pos && b.path == path

# VIEWMODEL , MODEL
func slots() -> Array:
	var arr: Array = []
	for i in range(buttons.size()):
		var slot = Slot.new()
		slot.pos = i
		slot.path = paths[buttons[i]]
		arr.push_back(slot)
	
	return arr

# VIEW & VIEWMODEL
func add_slots(slots: Array) -> void:
	set_disabled(true)
	slots.sort_custom(Slot, "comp")
	
	for slot in slots:
		
		var sketch = sketch_manager.get_sketch(slot.path)
		
		if sketch == null:
			var res = sketch_manager.make_sketch(slot.path)
			if ! res.ok():
				printerr("Failed to setup slot: %s" % res.error())
				continue
			sketch = sketch_manager.get_sketch(slot.path)
		
		var pane = _create_sketch_pane(sketch_manager.get_sketch(slot.path))
		if pane == null:
			continue
		_add_pane(pane, _new_slot())
		
	
	set_disabled(false)

