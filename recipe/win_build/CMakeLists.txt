cmake_minimum_required(VERSION 3.12.2)

project(MPC
  VERSION $ENV{PROJECT_VERSION}
  DESCRIPTION "A C library for the arithmetic of complex numbers with arbitrarily high precision."
  HOMEPAGE_URL "https://www.multiprecision.org/"
  LANGUAGES C)

# Pulled from src/Makefile.am's version param.
set(MPC_LT_CURRENT $ENV{LIB_MAJOR_VERSION})
#set(MPC_LT_CURRENT 3)
set(MPC_LT_AGE 1)
set(MPC_LT_REVISION 3)

option(RUN_TESTS "Enable tests suite" OFF)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Use solution folders for Visual Studio
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# config.h package information.
set(PACKAGE "mpc")
set(PACKAGE_NAME "mpc")
set(PACKAGE_TARNAME "mpc")
set(PACKAGE_VERSION "${MPC_VERSION}")
set(PACKAGE_STRING "${PACKAGE_NAME} ${MPC_VERSION}")
set(PACKAGE_URL "https://www.multiprecision.org/")
set(PACKAGE_BUGREPORT "mpc-discuss@inria.fr")
set(VERSION ${MPC_VERSION})
set(LT_OBJDIR ".lib")

# Package config values.
set(prefix "$ENV{PREFIX}")
set(exec_prefix "${prefix}")
set(includedir "${prefix}/include")
set(libdir "${exec_prefix}/lib")

include(CheckIncludeFile)
# vs2015 has partial support for complex arithmatic but not enough to build without errors.
# https://learn.microsoft.com/en-us/cpp/c-runtime-library/complex-math-support?view=msvc-160
#check_include_file(complex.h HAVE_COMPLEX_H)
check_include_file(dlfcn.h HAVE_DLFCN_H)
check_include_file(inttypes.h HAVE_INTTYPES_H)
check_include_file(memory.h HAVE_MEMORY_H)
check_include_file(stdint.h HAVE_STDINT_H)
check_include_file(stdlib.h HAVE_STDLIB_H)
check_include_file(strings.h HAVE_STRINGS_H)
check_include_file(string.h HAVE_STRING_H)
check_include_file(sys/stat.h HAVE_SYS_STAT_H)
check_include_file(sys/time.h HAVE_SYS_TIME_H)
check_include_file(sys/types.h HAVE_SYS_TYPES_H)
check_include_file(unistd.h HAVE_UNISTD_H)

include(CheckTypeSize)
check_type_size("intptr_t" INTPTR_T)
if(HAVE_INTPTR_T)
  set(SIZEOF_INTPTR_T ${INTPTR_T})
endif()
check_type_size("size_t" SIZE_T)
check_type_size("intmax_t" INTMAX_T)

include(CheckFunctionExists)
check_function_exists(dup HAVE_DUP)
check_function_exists(dup2 HAVE_DUP2)
check_function_exists(getrusage HAVE_GETRUSAGE)
check_function_exists(gettimeofday HAVE_GETTIMEOFDAY)
check_function_exists(localeconv HAVE_LOCALECONV)
check_function_exists(setlocale HAVE_SETLOCALE)

find_library(HAVE_LIBDL dl)
find_library(HAVE_LIBM m)

# MPC requires GMP version 5.0.0 or later and MPFR version 4.1.0 or later.
find_package(GMP 5.0.0 REQUIRED)
find_package(MPFR 4.1.0 REQUIRED)

if(MSVC)
  add_compile_options(/wd4018 /wd4146 /wd4244 /wd4267 /wd4996)
endif()

add_compile_definitions(HAVE_CONFIG_H)

configure_file(mpc.pc.in mpc.pc @ONLY)
configure_file(src/config.h.in config.h)

include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        ${CMAKE_CURRENT_BINARY_DIR})

add_subdirectory(src)
#add_subdirectory(tools/bench)

if(RUN_TESTS)
  include(CTest)
  enable_testing()
  add_subdirectory(tests)
endif()
