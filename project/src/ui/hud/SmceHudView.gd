extends Node

var hud_t = preload("res://src/ui/hud/SmceHud.tscn")

#onready var lpane = $LeftPane
#onready var left_panel = $Panel/VBoxContainer/ScrollContainer/VBoxContainer
#onready var attach = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/Control
#onready var new_sketch_btn = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/ToolButton
#onready var notification_display = $Notifications
#
#onready var profile_control = $ProfileControl
#onready var profile_control_toggle = $Panel/VBoxContainer/MarginContainer/VBoxContainer/ProfileControlToggle
#onready var profile_screen_toggle = $ProfileScreentoggle


var hud = null
var vm = SmceHudViewModel.new()

#var disabled = false setget set_disabled
#var buttons: Array = []
#
#var button_group: BButtonGroup = BButtonGroup.new()


# Called when the node enters the scene tree for the first time.
func _ready():
#	set_disabled()
#	button_group._init()
#	new_sketch_btn.connect("pressed", self, "_on_sketch_btn")
#	profile_control.connect("toggled", self, "_toggle_profile_control", [false])
#	profile_control_toggle.connect("pressed", self, "_toggle_profile_control", [true])
#	profile_screen_toggle.connect("button_down", self, "_toggle_profile_control", [false])
	
#	vm.connect("show_left_pane", self, "_show_left_pane") # SIGNAL FROM VM
#
#	print("IN SMCE_HUD_VIEW")
	vm.connect("update_hud", self, "_on_update_hud")
	
## ------------------
## SETTERS
## ------------------
#func set_disabled(val: bool = disabled) -> void:
#	disabled = val
#	for btn in buttons:
#		btn.disabled = val
#	if is_instance_valid(new_sketch_btn):
#		new_sketch_btn.disabled = val	
#
#func _show_left_pane(visible, node = null) -> void:
#	var tween: Tween = TempTween.new()
#	add_child(tween)
#
#	tween.interpolate_property(lpane, "rect_position:x", lpane.rect_position.x,  -int(!visible) * (lpane.rect_size.x) + int(visible) * 48, 0.25,Tween.TRANS_CUBIC)
#
#	if is_instance_valid(node):
#		tween.interpolate_property(node, "modulate:a", node.modulate.a, int(visible), 0.2)
#		tween.interpolate_property(node, "visible", node.visible, visible, 0.2)
#
#	tween.start()
#
#
#func _toggle_profile_control(show: bool) -> void:
#	var tween: Tween = TempTween.new()
#	add_child(tween)
#
#	profile_screen_toggle.visible = show
#	tween.interpolate_property(profile_control, "rect_position:x", profile_control.rect_position.x,  -int(!show) * (profile_control.rect_size.x) + int(!show) * -8, 0.25,Tween.TRANS_CUBIC)
#
#	tween.start()
	
func _on_update_hud(profile, slots) -> void:
	print("IN SMCE_HUD_VIEW : ON_UPDATE_HUD")
	if hud != null:
		hud.queue_free() # Remove from the scene tree so the old HUD instance doesn't show
	
	hud = hud_t.instance() # Make a new HUD since we removed the old one
	
	hud.cam_ctl = get_node("/root/Master/World").cam_ctl
	
	add_child(hud)
	hud.profile   = profile
	hud.add_slots(slots)
