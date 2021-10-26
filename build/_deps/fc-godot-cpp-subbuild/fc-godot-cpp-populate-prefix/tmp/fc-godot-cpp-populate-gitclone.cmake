
if(NOT "/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/_deps/fc-godot-cpp-subbuild/fc-godot-cpp-populate-prefix/src/fc-godot-cpp-populate-stamp/fc-godot-cpp-populate-gitinfo.txt" IS_NEWER_THAN "/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/_deps/fc-godot-cpp-subbuild/fc-godot-cpp-populate-prefix/src/fc-godot-cpp-populate-stamp/fc-godot-cpp-populate-gitclone-lastrun.txt")
  message(STATUS "Avoiding repeated git clone, stamp file is up to date: '/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/_deps/fc-godot-cpp-subbuild/fc-godot-cpp-populate-prefix/src/fc-godot-cpp-populate-stamp/fc-godot-cpp-populate-gitclone-lastrun.txt'")
  return()
endif()

execute_process(
  COMMAND ${CMAKE_COMMAND} -E rm -rf "/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/_deps/fc-godot-cpp-src"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to remove directory: '/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/_deps/fc-godot-cpp-src'")
endif()

# try the clone 3 times in case there is an odd git clone issue
set(error_code 1)
set(number_of_tries 0)
while(error_code AND number_of_tries LESS 3)
  execute_process(
    COMMAND "/usr/local/bin/git"  clone --no-checkout --depth 1 --no-single-branch --config "advice.detachedHead=false" "https://github.com/godotengine/godot-cpp.git" "fc-godot-cpp-src"
    WORKING_DIRECTORY "/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/_deps"
    RESULT_VARIABLE error_code
    )
  math(EXPR number_of_tries "${number_of_tries} + 1")
endwhile()
if(number_of_tries GREATER 1)
  message(STATUS "Had to git clone more than once:
          ${number_of_tries} times.")
endif()
if(error_code)
  message(FATAL_ERROR "Failed to clone repository: 'https://github.com/godotengine/godot-cpp.git'")
endif()

execute_process(
  COMMAND "/usr/local/bin/git"  checkout 3.x --
  WORKING_DIRECTORY "/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/_deps/fc-godot-cpp-src"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to checkout tag: '3.x'")
endif()

set(init_submodules TRUE)
if(init_submodules)
  execute_process(
    COMMAND "/usr/local/bin/git"  submodule update --recursive --init 
    WORKING_DIRECTORY "/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/_deps/fc-godot-cpp-src"
    RESULT_VARIABLE error_code
    )
endif()
if(error_code)
  message(FATAL_ERROR "Failed to update submodules in: '/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/_deps/fc-godot-cpp-src'")
endif()

# Complete success, update the script-last-run stamp file:
#
execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy
    "/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/_deps/fc-godot-cpp-subbuild/fc-godot-cpp-populate-prefix/src/fc-godot-cpp-populate-stamp/fc-godot-cpp-populate-gitinfo.txt"
    "/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/_deps/fc-godot-cpp-subbuild/fc-godot-cpp-populate-prefix/src/fc-godot-cpp-populate-stamp/fc-godot-cpp-populate-gitclone-lastrun.txt"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to copy script-last-run stamp file: '/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/_deps/fc-godot-cpp-subbuild/fc-godot-cpp-populate-prefix/src/fc-godot-cpp-populate-stamp/fc-godot-cpp-populate-gitclone-lastrun.txt'")
endif()

