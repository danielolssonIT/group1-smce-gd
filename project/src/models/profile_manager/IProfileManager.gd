#
#  IProfileManager.gd
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
class_name IProfileManager

func load_orig_profile():
	assert(false, "load_orig_profile must be implemented by a subclass of IProfileManager")

func load_active_profile():
	assert(false, "load_active_profile must be implemented by a subclass of IProfileManager")

func load_profile(profile: ProfileConfig):
	assert(false, "load_profile must be implemented by a subclass of IProfileManager")

# handles the loading of profiles
func load_profiles():
	assert(false, "load_profiles must be implemented by a subclass of IProfileManager")

# Handles the saving of a profile
func save_profile(profile: ProfileConfig):
	assert(false, "save_profile must be implemented by a subclass of IProfileManager")

func save_profiles(profiles: Array):
	assert(false, "save_profiles must be implemented by a subclass of IProfileManager")
