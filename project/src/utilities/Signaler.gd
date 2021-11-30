class_name Signaler

extends Node

var signals = null setget set_signals_handler

# Should be defined in the class that extends this class
func get_child_signalers():
	pass

func set_signals_handler(signal_handler):
	var _class_name = name
	print("IN " + _class_name + "SET_SIGNALS_HANDLER")
	signals = signal_handler
	var children = get_child_signalers()
	if children == null:
		return
	
	for child in children:
		child.set_signals_handler(signal_handler)

