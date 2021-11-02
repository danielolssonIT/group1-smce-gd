extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# this var triggers when setting the profile_selector in other script
var profile_selector_view = null setget set_view, get_view


func _init():
	print("ProfileSelectorViewModel")
	

func _ready() -> void:
	print("IN READY")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_profile_selected(profile: ProfileConfig) -> void:
	print("ProfileSelectorViewModel: on_profile_selected called!")
	
	# checks if profile selected is valid
	if ! is_instance_valid(profile):
		printerr("Invalid profile selected")
		return


func set_view(view):
	print("IN SET_VIEW")
	profile_selector_view = view
		# Setup the signal "profile_selected" to call "_on_profile_selected"
	profile_selector_view.connect("profile_selected", self, "_on_profile_selected")


func get_view():
	return profile_selector_view
