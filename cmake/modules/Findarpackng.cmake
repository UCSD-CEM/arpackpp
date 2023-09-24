if (NOT WIN32)
  find_package(PkgConfig QUIET)
  if (PKG_CONFIG_FOUND)
    pkg_check_modules(ARPACK arpack QUIET)
  endif ()
endif ()

if ( NOT ARPACK_FOUND )
  find_path(ARPACK_INCLUDE_DIRS
    NAMES arpack.h
    PATHS
      /usr/include
      /usr/local/include
    PATH_SUFFIXES
      arpack)

  find_library(ARPACK_LIBRARIES
    NAMES arpack
    PATHS
      /usr/lib
      /usr/local/lib)

  if ( NOT "${ARPACK_LIBRARIES}" STREQUAL "")
    set (ARPACK_FOUND TRUE)
    set (ARPACK_LINK_LIBRARIES ${ARPACK_LINK_LIBRARIES} ${ARPACK_LIBRARIES})
  endif ()
endif ()

include (FindPackageHandleStandardArgs)

find_package_handle_standard_args ( arpackng
    REQUIRED_VARS ARPACK_LINK_LIBRARIES ARPACK_INCLUDE_DIRS
    VERSION_VAR ARPACK_VERSION
)

mark_as_advanced (
    ARPACK_INCLUDE_DIRS
    ARPACK_LIBRARIES
)

if ( ARPACK_FOUND AND NOT TARGET ARPACK::ARPACK )
  add_library(ARPACK::ARPACK INTERFACE IMPORTED GLOBAL)
  set_target_properties(ARPACK::ARPACK
    PROPERTIES
      VERSION "${ARPACK_VERSION}"
      LOCATION "${ARPACK_LINK_LIBRARIES}"
      INTERFACE_INCLUDE_DIRECTORIES "${ARPACK_INCLUDE_DIRS}"
      INTERFACE_LINK_LIBRARIES "${ARPACK_LINK_LIBRARIES}")
endif ()

