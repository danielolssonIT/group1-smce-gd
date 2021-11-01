extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var profile_selector = null

func _init(_profile_selector):
	print("ProfileSelectorViewModel")
	profile_selector = _profile_selector
	

func _ready() -> void:
	# Setup the signal "profile_selected" to call "_on_profile_sel"
	profile_selector.connect("profile_selected", self, "_on_profile_selected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_profile_selected(profile: ProfileConfig) -> void:
	print("ProfileSelectorViewModel: on_profile_selected called!")
	
	# checks if profile selected is valid
	if ! is_instance_valid(profile):
		printerr("Invalid profile selected")
		return
