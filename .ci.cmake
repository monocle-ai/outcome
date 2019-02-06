# CTest script for a CI to submit to CDash a run of configuration,
# building and testing
cmake_minimum_required(VERSION 3.1 FATAL_ERROR)
include(cmake/QuickCppLibBootstrap.cmake)
include(QuickCppLibUtils)


CONFIGURE_CTEST_SCRIPT_FOR_CDASH("outcome" "cmake_ci")
ctest_empty_binary_directory(${CTEST_BINARY_DIRECTORY})
include(FindGit)
set(CTEST_GIT_COMMAND "${GIT_EXECUTABLE}")

ctest_start("Experimental")
ctest_update()
ctest_configure()
ctest_build()
ctest_test(RETURN_VALUE retval)
set(retval2 0)
set(retval3 0)
if(("$ENV{CXX}" MATCHES "clang"))
  ctest_build(TARGET _hl-asan)
  set(CTEST_CONFIGURATION_TYPE "asan")
  ctest_test(RETURN_VALUE retval2)
  ctest_build(TARGET _hl-ubsan)
  set(CTEST_CONFIGURATION_TYPE "ubsan")
  ctest_test(RETURN_VALUE retval3)
endif()
merge_junit_results_into_ctest_xml()
#ctest_upload(FILES )
ctest_submit()
if(NOT retval EQUAL 0 OR NOT retval2 EQUAL 0 OR NOT retval3 EQUAL 0)
  message(FATAL_ERROR "FATAL: Running tests exited with ${retval} ${retval2} ${retval3}")
endif()
