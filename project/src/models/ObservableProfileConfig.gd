class_name ObservableProfileConfig

signal profile_changed
signal profile_name_changed
signal environment_changed
signal slots_changed

var _profile = ProfileConfig.new()

var profile_name = null setget set_profile_name, get_profile_name
var environment = null setget set_environment, get_environment
var slots = null setget set_slots, get_slots

func type_info() -> Dictionary:
	return _profile.type_info()

func is_equal(other) -> bool:
	return _profile.is_equal(other)

# SETTERS AND GETTERS

func set_profile_name(value):
	_profile.profile_name = value
	emit_signal("profile_name_changed", value)
	emit_signal("profile_changed", self)

func get_profile_name():
	return _profile.profile_name

func set_environment(value):
	_profile.environment = value
	emit_signal("environment_changed", value)
	emit_signal("profile_changed", self)

func get_environment():
	return _profile.environment

func set_slots(value):
	_profile.slots = value
	emit_signal("slots_changed", value)
	emit_signal("profile_changed", self)

func get_slots():
	return _profile.slots
