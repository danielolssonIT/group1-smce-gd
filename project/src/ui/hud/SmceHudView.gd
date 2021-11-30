extends Node

var hud_t = preload("res://src/ui/hud/SmceHud.tscn")
var hud = null
var vm = SmceHudViewModel.new()
var channel = null setget set_channel

func _init():
	name = "SmceHudView"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("IN SMCE_HUD_VIEW _ready()")
	vm.connect("update_hud", self, "_on_update_hud")

func set_channel(_channel):	
	channel = _channel
	
	for child in [vm]:
		child.set_channel(_channel)
		
func _on_update_hud(profile, slots) -> void:
	print("IN SMCE_HUD_VIEW : ON_UPDATE_HUD")
	if hud != null:
		hud.queue_free() # Remove from the scene tree so the old HUD instance doesn't show
	
	hud = hud_t.instance() # Make a new HUD since we removed the old one
	
	hud.cam_ctl = get_node("/root/Master/World").cam_ctl
	
	
	add_child(hud)
	
	hud.channel = channel
	hud.profile   = profile
	hud.add_slots(slots)
