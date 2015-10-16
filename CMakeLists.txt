project (arpackpp)
cmake_minimum_required (VERSION 2.8)

option(SuperLU "Enable SuperLU" OFF)
option(UMFPACK "Enable UMFPACK" OFF)
option(CHOLMOD "Enable CHOLMOD" OFF)

function(examples list_name)
    foreach(l ${${list_name}})
        get_filename_component(lwe ${l} NAME_WE)
        add_executable(${lwe} ${l})
        target_link_libraries(${lwe} ${ARPACK_LIB} ${BLAS_LIBRARIES} ${LAPACK_LIBRARIES} ${GFORTRAN_LIB})
    endforeach()
endfunction(examples)

function(examplesslu list_name)
    foreach(l ${${list_name}})
        get_filename_component(lwe ${l} NAME_WE)
        add_executable(${lwe} ${l})
        target_link_libraries(${lwe} ${SUPERLU_LIB} ${ARPACK_LIB} ${BLAS_LIBRARIES} ${LAPACK_LIBRARIES} ${GFORTRAN_LIB})
    endforeach()
endfunction(examplesslu)

function(examplesls list_name)
    foreach(l ${${list_name}})
        get_filename_component(lwe ${l} NAME_WE)
        add_executable(${lwe} ${l})
        target_link_libraries(${lwe} ${ARPACK_LIB} ${SSPARSE_LIBS} ${BLAS_LIBRARIES} ${LAPACK_LIBRARIES} ${GFORTRAN_LIB})
    endforeach()
endfunction(examplesls)


find_package(LAPACK REQUIRED)
#IF(NOT BLAS_goto2_LIBRARY)
#  set(BLAS_goto2_LIBRARY ${CMAKE_SOURCE_DIR}/external/libopenblas.a CACHE STRING "ddd")
#ENDIF()
find_package(BLAS REQUIRED)

IF(WIN32)
    SET(CMAKE_FIND_LIBRARY_SUFFIXES .lib .a ${CMAKE_FIND_LIBRARY_SUFFIXES})
ELSE(WIN32)
    SET(CMAKE_FIND_LIBRARY_SUFFIXES .a ${CMAKE_FIND_LIBRARY_SUFFIXES})
ENDIF(WIN32)

IF(NOT WIN32)
      # Query gfortran to get the libgfortran.so path
#      FIND_PROGRAM(_GFORTRAN_EXECUTABLE NAMES gfortran)
      FIND_PROGRAM(_GFORTRAN_EXECUTABLE NAMES gfortran gfortran-mp-4.9)
      IF(_GFORTRAN_EXECUTABLE)
        EXECUTE_PROCESS(COMMAND ${_GFORTRAN_EXECUTABLE} -print-file-name=libgfortran.a
                        OUTPUT_VARIABLE _libgfortran_path
                        OUTPUT_STRIP_TRAILING_WHITESPACE
                       )
      ENDIF()
      unset(_GFORTRAN_EXECUTABLE CACHE)

      IF(EXISTS ${_libgfortran_path})
        get_filename_component(GFORTRAN_PATH ${_libgfortran_path} PATH)
#        SET(GFORTRAN_LIB ${_libgfortran_path} CACHE STRING "gfortran library)
        find_library(GFORTRAN_LIB gfortran PATHS ${GFORTRAN_PATH})
      ELSE()
        # if libgfortran wasn't found at this point, the installation is probably broken
        # Let's try to find the library nonetheless.
        FIND_LIBRARY(GFORTRAN_LIB gfortran)
      ENDIF()
      IF (NOT GFORTRAN_LIB)
        MESSAGE(STATUS "gfortran is required but could not be found")
        SET(ABORT_CONFIG TRUE)
      ENDIF (NOT GFORTRAN_LIB)
ENDIF(NOT WIN32)

# ARPACK
find_library(ARPACK_LIB  libarpack.a "external")

# SUPERLU
if (SuperLU)
  find_path(SUPERLU_INC supermatrix.h "external/SuperLU/SRC")
  find_library(SUPERLU_LIB superlu.a libsuperlu.a  
    PATHS ${SUPERLU_INC} ${SUPERLU_INC}/../ external )
  #set(SUPERLU_COMPILE_FLAGS "-DSUPERLU3")
  include_directories( ${SUPERLU_INC} )
endif()

if (UMFPACK OR CHOLMOD)
  # Suitesparse CHOLMOD
  find_path(SUITESPARSE_DIR SuiteSparse_config/SuiteSparse_config.h "external/SuiteSparse")
  find_library(CHOLMOD_LIB libcholmod.a ${SUITESPARSE_DIR}/CHOLMOD/Lib  )
  find_library(COLAMD_LIB libcolamd.a ${SUITESPARSE_DIR}/COLAMD/Lib  )
  find_library(CCOLAMD_LIB libccolamd.a ${SUITESPARSE_DIR}/CCOLAMD/Lib  )
  find_library(METIS_LIB libmetis.a ${SUITESPARSE_DIR}/metis-4.0 )
  find_library(CAMD_LIB libcamd.a ${SUITESPARSE_DIR}/CAMD/Lib )
  find_library(AMD_LIB libamd.a ${SUITESPARSE_DIR}/AMD/Lib )

  # UMFPACK
  find_library(UMFPACK_LIB libumfpack.a ${SUITESPARSE_DIR}/UMFPACK/Lib  )
  find_library(SUITESPARSE_LIB libsuitesparseconfig.a ${SUITESPARSE_DIR}/SuiteSparse_config )

  set(SSPARSE_LIBS
    ${UMFPACK_LIB}
    ${CHOLMOD_LIB}
    ${COLAMD_LIB}
    ${CCOLAMD_LIB}
    ${METIS_LIB}
    ${CAMD_LIB}
    ${AMD_LIB}
    ${SUITESPARSE_LIB} 
  )
  
  include_directories(
    ${SUITESPARSE_DIR}/CHOLMOD/Include
    ${SUITESPARSE_DIR}/SuiteSparse_config
  )

endif()

include_directories(
  include
  examples/matrices/complex
  examples/matrices/nonsym
  examples/matrices/sym
  examples/matprod
  examples/matprod/complex
  examples/matprod/nonsym
  examples/matprod/sym
  examples/areig
  
)

# examples product
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/examples/product/)
file(GLOB product_complex examples/product/complex/*.cc)
examples(product_complex)
file(GLOB product_nonsym examples/product/nonsym/*.cc)
examples(product_nonsym)
file(GLOB product_simple examples/product/simple/*.cc)
examples(product_simple)
file(GLOB product_sym examples/product/sym/*.cc)
examples(product_sym)

# examples reverse
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/examples/reverse/)
file(GLOB reverse_complex examples/reverse/complex/*.cc)
examples(reverse_complex)
file(GLOB reverse_nonsym examples/reverse/nonsym/*.cc)
examples(reverse_nonsym)
file(GLOB reverse_sym examples/reverse/sym/*.cc)
examples(reverse_sym)

# examples band
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/examples/band/)
file(GLOB band_complex examples/band/complex/*.cc)
examples(band_complex)
file(GLOB band_nonsym examples/band/nonsym/*.cc)
examples(band_nonsym)
file(GLOB band_sym examples/band/sym/*.cc)
examples(band_sym)

# examples dense
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/examples/dense/)
file(GLOB dense_complex examples/dense/complex/*.cc)
examples(dense_complex)
file(GLOB dense_nonsym examples/dense/nonsym/*.cc)
examples(dense_nonsym)
file(GLOB dense_sym examples/dense/sym/*.cc)
examples(dense_sym)




if (SuperLU)

  # examples areig
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/examples/areig/)
  file(GLOB areig_complex examples/areig/complex/*.cc)
  examplesslu(areig_complex)
  file(GLOB areig_nonsym examples/areig/nonsym/*.cc)
  examplesslu(areig_nonsym)
  file(GLOB areig_sym examples/areig/sym/*.cc)
  examplesslu(areig_sym)

  # examples superlu
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/examples/superlu/)
  file(GLOB superlu_complex examples/superlu/complex/*.cc)
  examplesslu(superlu_complex)
  file(GLOB superlu_nonsym examples/superlu/nonsym/*.cc)
  examplesslu(superlu_nonsym)
  file(GLOB superlu_sym examples/superlu/sym/*.cc)
  examplesslu(superlu_sym)

  # examples harwell (needs SuperLU)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/examples/harwell/)
  file(GLOB harwell_complex examples/harwell/complex/*.cc)
  examplesslu(harwell_complex)
  file(GLOB harwell_nonsym examples/harwell/nonsym/*.cc)
  examplesslu(harwell_nonsym)
  file(GLOB harwell_sym examples/harwell/sym/*.cc)
  examplesslu(harwell_sym)
  # also copy binaries
  add_custom_target(harwellbin ALL
    COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/examples/harwell/complex/mhd1280a.cua.gz" ${CMAKE_BINARY_DIR}/examples/harwell/ 
    COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/examples/harwell/complex/mhd1280b.cua.gz" ${CMAKE_BINARY_DIR}/examples/harwell/ 
    COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/examples/harwell/nonsym/mhd416a.rua" ${CMAKE_BINARY_DIR}/examples/harwell/ 
    COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/examples/harwell/nonsym/mhd416b.rua" ${CMAKE_BINARY_DIR}/examples/harwell/ 
    COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/examples/harwell/sym/lund_a.rsa" ${CMAKE_BINARY_DIR}/examples/harwell/ 
    COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/examples/harwell/sym/lund_b.rsa" ${CMAKE_BINARY_DIR}/examples/harwell/ 
    COMMENT "Copying Harwell binary examples"
    SOURCES examples/harwell/complex/mhd1280a.cua.gz 
      examples/harwell/complex/mhd1280b.cua.gz 
      examples/harwell/nonsym/mhd416a.rua
      examples/harwell/nonsym/mhd416b.rua
      examples/harwell/sym/lund_a.rsa
      examples/harwell/sym/lund_b.rsa
  )
endif()

if (UMFPACK)
  
  # examples umfpack
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/examples/umfpack/)
  file(GLOB umfpack_complex examples/umfpack/complex/*.cc)
  #examplesls(umfpack_complex)
  file(GLOB umfpack_nonsym examples/umfpack/nonsym/*.cc)
  #examplesls(umfpack_nonsym)
  file(GLOB umfpack_sym examples/umfpack/sym/*.cc)
  examplesls(umfpack_sym)
    
endif()

if (CHOLMOD)

  # examples cholmod
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/examples/cholmod/)
  file(GLOB cholmod_sym examples/cholmod/sym/*.cc)
  examplesls(cholmod_sym)

endif()