if (NOT WIN32)
  find_package(PkgConfig QUIET)
  if (PKG_CONFIG_FOUND)
    pkg_check_modules(SUPERLU superlu QUIET)
  endif ()
endif ()

if ( NOT SUPERLU_FOUND )
  find_path(SUPERLU_INCLUDE_DIRS
    NAMES slu_util.h
    PATHS
      /usr/include
      /usr/local/include
    PATH_SUFFIXES
      superlu)

  find_library(SUPERLU_LIBRARIES
    NAMES superlu
    PATHS
      /usr/lib
      /usr/local/lib)

  if ( NOT "${SUPERLU_LIBRARIES}" STREQUAL "")
    set (SUPERLU_FOUND TRUE)
    set (SUPERLU_LINK_LIBRARIES ${SUPERLU_LINK_LIBRARIES} ${SUPERLU_LIBRARIES})
  endif ()
endif ()

if ( EXISTS "${SUPERLU_INCLUDE_DIRS}" AND NOT SUPERLU_VERSION )
  file ( STRINGS ${SUPERLU_INCLUDE_DIRS}/slu_util.h SUPERLU_MAJOR_STR
    REGEX "define SUPERLU_MAJOR_VERSION" )
  file ( STRINGS ${SUPERLU_INCLUDE_DIRS}/slu_util.h SUPERLU_MINOR_STR
    REGEX "define SUPERLU_MINOR_VERSION" )
  file ( STRINGS ${SUPERLU_INCLUDE_DIRS}/slu_util.h SUPERLU_PATCH_STR
    REGEX "define SUPERLU_PATCH_VERSION" )
  string ( REGEX MATCH "[0-9]+" SUPERLU_MAJOR ${SUPERLU_MAJOR_STR} )
  string ( REGEX MATCH "[0-9]+" SUPERLU_MINOR ${SUPERLU_MINOR_STR} )
  string ( REGEX MATCH "[0-9]+" SUPERLU_PATCH ${SUPERLU_PATCH_STR} )
  set (SUPERLU_VERSION "${SUPERLU_MAJOR}.${SUPERLU_MINOR}.${SUPERLU_PATCH}")
endif ()

include (FindPackageHandleStandardArgs)

find_package_handle_standard_args ( superlu
    REQUIRED_VARS SUPERLU_LINK_LIBRARIES SUPERLU_INCLUDE_DIRS
    VERSION_VAR SUPERLU_VERSION
)

mark_as_advanced (
    SUPERLU_INCLUDE_DIRS
    SUPERLU_LIBRARIES
)

if ( SUPERLU_FOUND AND NOT TARGET superlu::superlu )
  add_library(superlu::superlu INTERFACE IMPORTED GLOBAL)
  set_target_properties(superlu::superlu
    PROPERTIES
      VERSION "${SUPERLU_VERSION}"
      LOCATION "${SUPERLU_LINK_LIBRARIES}"
      INTERFACE_INCLUDE_DIRECTORIES "${SUPERLU_INCLUDE_DIRS}"
      INTERFACE_LINK_LIBRARIES "${SUPERLU_LINK_LIBRARIES}")
endif ()

