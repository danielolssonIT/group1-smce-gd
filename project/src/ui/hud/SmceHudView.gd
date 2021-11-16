extends Node

var hud_t = preload("res://src/ui/hud/SmceHud.tscn")
var hud = null
onready var world = get_node("/root/Master/World")
var vm = SmceHudViewModel.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("IN SMCE_HUD_VIEW")
	vm.connect("update_hud", self, "_on_update_hud")
	
func _on_update_hud(profile, slots) -> void:
	print("IN ON_UPDATE_HUD")
	if hud != null:
		hud.queue_free()
	# SETUP all the resources every time a profile has been loaded 
	# and apply them into the SmceHud variables
	hud = hud_t.instance() # Apply the SmceHud menu when a profile has been loaded
	hud.cam_ctl = world.cam_ctl
	# FIX IN FUTURE WHEN REFACTORING SMCE HUD
	#hud.sketch_manager = sketch_manager
	add_child(hud)
	hud.profile   = profile
	hud.add_slots(slots)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
