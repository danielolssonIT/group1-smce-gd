# Install script for directory: /Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/Library/Developer/CommandLineTools/usr/bin/objdump")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  find_program (GODOT_EXECUTABLE NAMES godot3-headless godot-headless godot3-server godot-server godot3 godot REQUIRED)
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  
        execute_process (COMMAND "${GODOT_EXECUTABLE}" --no-window --export "macos" "/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/export/SMCE-Godot"
                         WORKING_DIRECTORY "/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/project")
        if (NOT EXISTS "/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/export/SMCE-Godot")
            message (FATAL_ERROR "Godot export failure")
        endif ()
        execute_process (COMMAND "/Applications/CMake.app/Contents/bin/cmake" -E tar xf "/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/export/SMCE-Godot"
                         WORKING_DIRECTORY "/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/export")
        execute_process (COMMAND defaults write "/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/export/SMCE-Godot.app/Contents/Info.plist" LSEnvironment -dict PATH "/bin:/usr/bin:/usr/local/bin:/opt/homebrew/bin:")
    
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  
        file (INSTALL "/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/export/SMCE-Godot.app" DESTINATION "${CMAKE_INSTALL_PREFIX}" USE_SOURCE_PERMISSIONS)
    
endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/Users/Clabbe/Documents/Skola/Software Evolution Project/group1-smce-gd/build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
