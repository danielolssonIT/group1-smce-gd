class_name SignalerControl

extends Control

var channel = null setget set_channel

# Should be defined in the class that extends this class
func get_child_signalers():
	return []

func set_channel(_channel):
	var _class_name = name
	print("IN " + _class_name + "SET_SIGNALS_HANDLER")
	channel = _channel
	var children = get_child_signalers()
	if children == null:
		return
	
	for child in children:
		child.set_channel(_channel)

