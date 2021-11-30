extends Node

class_name SmceHudViewModel

signal update_hud

var channel = null setget set_channel

# Called when the node enters the scene tree for the first time.
func _init():
	name = "SmceHudViewModel"

func set_channel(_channel):	
	channel = _channel
	
	channel.connect("profile_loaded", self, "_on_profile_loaded")
	

func _on_profile_loaded(profile) -> void:
	print("IN SMCE_HUD_VIEW_MODEL: _ON_PROFILE_LOADED")
	emit_signal("update_hud", profile, profile.slots)
