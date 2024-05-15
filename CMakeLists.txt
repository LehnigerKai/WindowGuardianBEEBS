# The following lines of boilerplate have to be in your project's
# CMakeLists in this exact order for cmake to work correctly
cmake_minimum_required(VERSION 3.5)
set(EXTRA_COMPONENT_DIRS components)
include($ENV{IDF_PATH}/tools/cmake/project.cmake)
set(ENV{BENCHMARK} $CACHE{BENCHMARK})
#set(ENV{BENCHMARK} "wikisort") 
project(app-template)
idf_build_set_property(COMPILE_OPTIONS -DSEC_METHOD=${SEC_METHOD} APPEND)
