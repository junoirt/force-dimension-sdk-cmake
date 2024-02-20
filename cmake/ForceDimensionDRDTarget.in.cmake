cmake_policy(PUSH)
cmake_policy(VERSION 3.5)

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Protect against multiple inclusion, which would fail when already imported targets are added once more.
set(_targetsDefined)
set(_targetsNotDefined)
set(_expectedTargets)
foreach(_expectedTarget @TARGET_NAME@)
  list(APPEND _expectedTargets ${_expectedTarget})
  if(NOT TARGET ${_expectedTarget})
    list(APPEND _targetsNotDefined ${_expectedTarget})
  endif()
  if(TARGET ${_expectedTarget})
    list(APPEND _targetsDefined ${_expectedTarget})
  endif()
endforeach()
if("${_targetsDefined}" STREQUAL "${_expectedTargets}")
  unset(_targetsDefined)
  unset(_targetsNotDefined)
  unset(_expectedTargets)
  set(CMAKE_IMPORT_FILE_VERSION)
  cmake_policy(POP)
  return()
endif()
if(NOT "${_targetsDefined}" STREQUAL "")
  message(FATAL_ERROR "Some (but not all) targets in this export set were already defined.\nTargets Defined: ${_targetsDefined}\nTargets not yet defined: ${_targetsNotDefined}\n")
endif()
unset(_targetsDefined)
unset(_targetsNotDefined)
unset(_expectedTargets)

# Compute the installation prefix relative to this file.
get_filename_component(_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_FILE}" PATH)
# Use original install prefix when loaded through a
# cross-prefix symbolic link such as /lib -> /usr/lib.
get_filename_component(_realCurr "${_IMPORT_PREFIX}" REALPATH)
get_filename_component(_realOrig "@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@/cmake/ForceDimension" REALPATH)
if(_realCurr STREQUAL _realOrig)
  set(_IMPORT_PREFIX "@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@/cmake/ForceDimension")
endif()
unset(_realOrig)
unset(_realCurr)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
if(_IMPORT_PREFIX STREQUAL "/")
  set(_IMPORT_PREFIX "")
endif()

# Create imported target @TARGET_NAME@
add_library(@TARGET_NAME@ SHARED IMPORTED)

# Import target "@TARGET_NAME@" for configuration "@CMAKE_BUILD_TYPE@"
set_property(TARGET @TARGET_NAME@ APPEND PROPERTY IMPORTED_CONFIGURATIONS @CMAKE_BUILD_TYPE@)
set_target_properties(@TARGET_NAME@ PROPERTIES
  IMPORTED_NO_SONAME TRUE
  IMPORTED_LOCATION_@CMAKE_BUILD_TYPE@ "@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@/libdrd.so.3.17.0"
  IMPORTED_LOCATION "@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@/libdrd.so.3.17.0"
  IMPORTED_IMPLIB "@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@/libdrd.a"
  INTERFACE_INCLUDE_DIRECTORIES "@CMAKE_INSTALL_PREFIX@/include/forcedimension"
  INTERFACE_LINK_LIBRARIES "-lpthread -lusb-1.0 -lrt -ldl"
)

list(APPEND _IMPORT_CHECK_TARGETS @TARGET_NAME@ )
list(APPEND _IMPORT_CHECK_FILES_FOR_@TARGET_NAME@ "@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@/libdrd.so.3.17.0" )

if(CMAKE_VERSION VERSION_LESS 3.5.0)
  message(FATAL_ERROR "This file relies on consumers using CMake 3.5.0 or greater.")
endif()

# Cleanup temporary variables.
set(_IMPORT_PREFIX)

# Loop over all imported files and verify that they actually exist
foreach(target ${_IMPORT_CHECK_TARGETS} )
  foreach(file ${_IMPORT_CHECK_FILES_FOR_${target}} )
    if(NOT EXISTS "${file}" )
      message(FATAL_ERROR "The imported target \"${target}\" references the file
              \"${file}\"
              but this file does not exist.  Possible reasons include:
              * The file was deleted, renamed, or moved to another location.
              * An install or uninstall procedure did not complete successfully.
              * The installation package was faulty and contained
                \"${CMAKE_CURRENT_LIST_FILE}\"
              but not all the files it references."
             )
    endif()
  endforeach()
  unset(_IMPORT_CHECK_FILES_FOR_${target})
endforeach()
unset(_IMPORT_CHECK_TARGETS)

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
cmake_policy(POP)
