class_name Channel

extends Node

# Request = a signal that tells some other script to do something
# Event = a signal that tells other scripts that something has happened

# UI Requests
signal update_selected_world
signal update_save_btn_disabled
signal show_profile_select

# Profile Events
signal active_profile_changed
signal profile_loaded
signal active_profile_equals_orig_profile
signal broadcast_active_profile

# Profile Requests
signal save_active_profile
signal update_active_profile_name
signal load_active_profile
signal read_active_profile
signal load_profile
signal reload_profile

func _init():
	pass
