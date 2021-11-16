extends Node

class_name SmceHudViewModel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal update_hud

var profile_manager = Global.profile_manager

# Called when the node enters the scene tree for the first time.
func _init():
	profile_manager.connect("profile_loaded", self, "_on_profile_loaded")

func _on_profile_loaded(profile) -> void:
	print("IN SMCE_HUD_VIEW_MODEL: _ON_PROFILE_LOADED")
	emit_signal("update_hud", profile, profile.slots)
