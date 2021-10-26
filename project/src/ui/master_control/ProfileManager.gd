#
#  ProfileManager.gd
#  Copyright 2021 ItJustWorksTM
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

class_name ProfileManager
extends Reference

# A mapping from a profile to the path (in system directory) of the profile
var saved_profiles: Dictionary = {}

# handles the loading of profiles
func load_profiles() -> Array:
	var profile_path = Global.usr_dir_plus("config/profiles")
	var profiles = []
	saved_profiles = {}
	
	# For all profile files in the path,
	# save the corresponding profile and the path to the file
	# in the "profiles"-array and the "saved_profiles"-dictionary
	for profile_file in Util.ls(profile_path):
		# path/to/profile + profile_file = path/to/profile/profile_file
		var path: String = profile_path.plus_file(profile_file)
		
		# Try to open the file, if not possible move on to next loop iteration
		var file = File.new()
		if file.open(path, File.READ) != OK:
			printerr("failed to read: %s" % path)
			continue
		
		# Read the json data for the profile
		var json = file.get_as_text()
		var parse_res := JSON.parse(json)
		
		# Check if the JSON result is a dictionary
		if ! parse_res.result is Dictionary:
			printerr("%s: not a dictionairy" % path)
		
		# Create a new profile object
		var profile = ProfileConfig.new()
		Util.inflate_ref(profile, parse_res.result)
		
		# Save the profile object in the array(profiles) and path to the profile file in the dictionary(saved_profiles)
		profiles.push_back(profile)
		saved_profiles[profile] = path
		
		print("loaded profile: %s" % profile.profile_name)
	
	return profiles

# Handles the saving of a profile
func save_profile(profile: ProfileConfig) -> bool:
	# get the path of the profile, and create a new Directory var
	var profile_path = Global.usr_dir_plus("config/profiles")
	var dir: Directory = Directory.new()
	
	# check if the path of the profile exist
	if ! dir.dir_exists(profile_path) && ! Util.mkdir(profile_path, true):
		return false
	
	# check if the profile is in the Dictionary saved_profiles(profile has been loaded)
	# then set the corresponding path of profile to profile_path 
	if saved_profiles.has(profile):
		profile_path = saved_profiles[profile]
	else:
		# Basically this is stupid but it works
		var i = 0
		while dir.file_exists(profile_path.plus_file("%d.json" % i)):
			i += 1
		profile_path += "/%d.json" % i
	
	# check if file for the profile exist and if it is possible to remove it
	if dir.file_exists(profile_path) && dir.remove(profile_path) != OK:
		printerr("FAILED TO DELETE EXISTING PROFILE FILE")
		return false
	
	# create new File object
	var file := File.new()
	
	# attempt to open the profile file
	if file.open(profile_path, File.WRITE) != OK:
		printerr("FAILED TO OPEN NEW PROFILE FILE")
		return false
	
	var dict = Util.dictify(profile)
	var content = JSON.print(dict, "	")
	
	file.store_string(content)
	file.close()
	
	# set the path of the corresponding profile in the dictionary in order to save it
	saved_profiles[profile] = profile_path
	
	print("saved profile: ", profile.profile_name)
	return true


func save_profiles(profiles: Array) -> void:
	for profile in profiles:
		if ! save_profile(profile):
			print("Could not save profile: ", profile.profile_name)

