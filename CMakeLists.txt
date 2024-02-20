cmake_minimum_required(VERSION 3.19)

project(ForceDimension
        VERSION 3.17.0
        LANGUAGES C CXX
        DESCRIPTION "Force Dimension SDK"
)


# Provide a default install prefix to be /usr/local
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "/usr/local" CACHE PATH "..." FORCE)
  message(STATUS "No install prefix provided. Installing at '/usr/local'")
endif()

# Installation options
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

# Write a versioning file to use with find_package()
write_basic_package_version_file(
  ${PROJECT_NAME}ConfigVersion.cmake
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion
)

# Read a input config file and output it to the cmake binary folder
configure_package_config_file(
  ${PROJECT_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.in.cmake
  ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
  INSTALL_DESTINATION
  ${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}/cmake
)

add_library(ForceDimension::dhd SHARED IMPORTED GLOBAL)
add_library(ForceDimension::drd SHARED IMPORTED GLOBAL)

# Installation
get_target_property(TARGET_NAME ForceDimension::drd NAME)
configure_file(
  ${CMAKE_SOURCE_DIR}/cmake/ForceDimensionDRDTarget.in.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/ForceDimensionDRDTarget.cmake
  @ONLY
)

get_target_property(TARGET_NAME ForceDimension::dhd NAME)
configure_file(
  ${CMAKE_SOURCE_DIR}/cmake/ForceDimensionDHDTarget.in.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/ForceDimensionDHDTarget.cmake
  @ONLY
)

# Install all CMake package detection/configuration
install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/ForceDimensionDRDTarget.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/ForceDimensionDHDTarget.cmake
        ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
        ${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/forcedimension
)

# Install .so and .a files to the lib dir
install(
  FILES OEM/sdk/lib/release/lin-x86_64-gcc/libdrd.so.3.17.0
        OEM/sdk/lib/release/lin-x86_64-gcc/libdrd.a
        OEM/sdk/lib/release/lin-x86_64-gcc/libdhd.so.3.17.0
        OEM/sdk/lib/release/lin-x86_64-gcc/libdhd.a
  DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

# Install headers files to the include dir
install(
  DIRECTORY OEM/sdk/include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/forcedimension
)
