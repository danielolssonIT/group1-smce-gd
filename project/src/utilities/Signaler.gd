class_name Signaler

extends Node

var channel = null setget set_channel

# Should be defined in the class that extends this class
func get_child_signalers():
	pass

func set_channel(_channel):
	var _class_name = name
	print("IN " + _class_name + "SET_SIGNALS_HANDLER")
	channel = _channel
	var children = get_child_signalers()
	if children == null:
		return
	
	for child in children:
		child.set_channel(_channel)

