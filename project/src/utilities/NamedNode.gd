extends Node

class_name NamedNode

# Set name of node with script name
func _init():
	var file_name: String = self.get_script().resource_path.get_file()
	self.name = file_name.substr(0, len(file_name) - 3) # remove ".gd"
