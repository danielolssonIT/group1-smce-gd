class_name SignalerNode

extends Node

var channel = null setget set_channel

# Should be defined in the class that extends this class
func get_child_signalers():
	return []

# Should be defined in the class that extends this class
func on_channel_set():
	pass
	
func set_channel(_channel):
	var _class_name = name
	print("IN " + _class_name + " set_channel")
	
	channel = _channel
	on_channel_set()
	
	var children = get_child_signalers()
	if children == null:
		return
	
	for child in children:
		child.set_channel(_channel)
		

