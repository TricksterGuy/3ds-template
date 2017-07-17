cmake_minimum_required(VERSION 3.7)
project(3DSBuildTemplate)

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES
        source/main.h
        source/main.cpp
        source/graphics/Output.h
        source/graphics/Output.cpp)

# Specify external includes here
include_directories($ENV{DEVKITARM}/include/)
include_directories($ENV{DEVKITARM}/arm-none-eabi/include)
include_directories($ENV{DEVKITPRO}/libctru/include)
include_directories($ENV{DEVKITARM}/arm-none-eabi/include/c++/7.1.0)

add_executable(3DSBuildTemplate ${SOURCE_FILES})
