# Usage:
# mkdir build && cd build
# Mac:
#   # Get OpenMP support. Apple's XCode clang lacks it. `brew install llvm` is another option.
#   brew install gcc 
#   export MAC_DEPLOYMENT_TARGET=10.10
#   CC=/usr/local/bin/gcc-7 CXX=/usr/local/bin/g++-7 cmake -Wno-dev -DCMAKE_INSTALL_PREFIX:PATH=/tmp/clustalo -DCMAKE_VERBOSE_MAKEFILE=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-mmacosx-version-min=${MAC_DEPLOYMENT_TARGET}" -DCMAKE_CXX_FLAGS="-mmacosx-version-min=${MAC_DEPLOYMENT_TARGET}" ..
#   make -j && make install
# Linux:   
#   cmake -Wno-dev -DCMAKE_INSTALL_PREFIX:PATH=/tmp/clustalo -DCMAKE_VERBOSE_MAKEFILE=OFF -DCMAKE_BUILD_TYPE=Release ..
#   make -j && make install
# Windows: 
#   cmake -Wno-dev -DCMAKE_INSTALL_PREFIX:PATH=/tmp/clustalo -DCMAKE_VERBOSE_MAKEFILE=OFF -DCMAKE_BUILD_TYPE=Release -G "NMake Makefiles" ..
#   nmake && nmake install

cmake_minimum_required(VERSION 3.0)
project(ClustalOmega)

set(PACKAGE           "\"clustal-omega\"")
set(PACKAGE_NAME      "\"Clustal Omega\"")
set(PACKAGE_TARNAME   "\"clustal-omega\"")
set(PACKAGE_VERSION   "\"1.2.4\"")
set(PACKAGE_STRING    "\"Clustal Omega 1.2.4\"")
set(PACKAGE_BUGREPORT "\"clustalw@ucd.ie\"")
set(PACKAGE_CODENAME  "\"AndreaGiacomo\"")

# Find our local cmake modules.
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/modules/")

enable_language(C)
enable_language(CXX)

#----------------------------------------------------------
include(CheckIncludeFiles)
# Windows does not have: dlfcn.h strings.h unistd.h
check_include_files("assert.h;ctype.h;float.h;limits.h;math.h;memory.h;stdarg.h;stdio.h;stdlib.h;string.h;sys/stat.h;sys/types.h;time.h" HAVE_STDC_HEADERS)
if(NOT HAVE_STDC_HEADERS)
  message(FATAL_ERROR "Standard C headers not found.")
endif()

check_include_files(unistd.h HAVE_UNISTD_H)

include(CheckFunctionExists)
check_function_exists(log2     CLUSTAL_OMEGA_HAVE_LOG2)
check_function_exists(fseeko   HAVE_FSEEKO)
check_function_exists(fseek64  HAVE_FSEEK64)
check_function_exists(fseeko64 HAVE_FSEEKO64)
check_function_exists(ftello   HAVE_FTELLO)
check_function_exists(ftello64 HAVE_FTELLO64)
check_function_exists(ftell64  HAVE_FTELL64)
check_function_exists(ntohl    HAVE_NTOHL)
check_function_exists(ntohs    HAVE_NTOHS)
check_function_exists(strtoull HAVE_STRTOULL)

include(CheckTypeSize)
check_type_size(fpos_t          SIZEOF_FPOS_T)
check_type_size(off_t           SIZEOF_OFF_T)
check_type_size(off64_t         SIZEOF_OFF64_T)
check_type_size("unsigned long" SIZEOF_UNSIGNED_LONG)

if(NOT WIN32)
  find_library(HAVE_LIBM m)
  if(NOT HAVE_LIBM)
    message(FATAL_ERROR "Cannot find math m library file path; please add it to CMAKE_LIBRARY_PATH.")
  endif()
endif()

if(WIN32)
  add_definitions(-DSRE_STRICT_ANSI)
endif()

#----------------------------------------------------------
set(ARGTABLE_INCLUDE_DIR "" CACHE PATH "Where argbtable2 library headers can be found.")
set(ARGTABLE_LIBRARY_DIR "" CACHE PATH "Where argbtable2 static library file can be found.")

# Try custom dir first. If found, result is cached.s
find_library(HAVE_LIBARGTABLE NAMES argtable2 PATHS ${ARGTABLE_LIBRARY_DIR} NO_DEFAULT_PATH)
if(HAVE_LIBARGTABLE)
  link_directories(${ARGTABLE_LIBRARY_DIR})
endif()
# Fallback on system paths if no custom dir given.
find_library(HAVE_LIBARGTABLE argtable2)
if(NOT HAVE_LIBARGTABLE)
  message(FATAL_ERROR "Cannot find argtable2 library file path; please add it to ARGTABLE_LIBRARY_DIR.")
endif()

# Find in system paths plus any custom include dir.
check_include_file_cxx(argtable2.h HAVE_ARGTABLE_H "-I${ARGTABLE_INCLUDE_DIR}")
if(NOT HAVE_ARGTABLE_H)
  message(FATAL_ERROR "Cannot find argtable2 header file path; please add it to ARGTABLE_INCLUDE_DIR.")
else()
  include_directories(${ARGTABLE_INCLUDE_DIR})
endif()

#----------------------------------------------------------
set(ENABLE_OPENMP ON CACHE BOOL "Enable OpenMP.")
if(ENABLE_OPENMP)
  find_package(OpenMP REQUIRED)
  if(OPENMP_FOUND)
    set(CMAKE_C_FLAGS          "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
    set(CMAKE_CXX_FLAGS        "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
    set(HAVE_OPENMP 1)
  else()
    message("OpenMP NOT FOUND")
  endif()
else()
  message("OpenMP DISABLED")
endif()

#----------------------------------------------------------
include(TestBigEndian)
test_big_endian(HAVE_BIGENDIAN)
if(HAVE_BIGENDIAN)
  message("${CLUSTAL_OMEGA_PACKAGE} hasn't been tested on Big-Endian machines...expecting trouble!")
endif()

include(CheckInline)

include(CheckCSourceCompiles)
check_c_source_compiles("int main() { const int i = 1; }" HAVE_CONST)

#----------------------------------------------------------
configure_file(${CMAKE_SOURCE_DIR}/cmake/clustalo.pc.in 
               ${CMAKE_CURRENT_BINARY_DIR}/clustalo.pc
               @ONLY)

#----------------------------------------------------------
set(INSTALL_PKGCONFIG_DIR 
    "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" 
    CACHE 
    PATH 
    "Installation directory for pkgconfig (.pc) files.")
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/clustalo.pc DESTINATION ${INSTALL_PKGCONFIG_DIR})

set(INSTALL_INC_DIR 
    "${CMAKE_INSTALL_PREFIX}/include/clustalo" 
    CACHE 
    PATH 
    "Installation directory for headers.")
    
set(INSTALL_MAN_DIR
    "${CMAKE_INSTALL_PREFIX}/share/doc/clustal-omega"
    CACHE
    PATH 
    "Installation directory for documentation.")
install(FILES README DESTINATION ${INSTALL_MAN_DIR})

#----------------------------------------------------------
add_subdirectory(src)
