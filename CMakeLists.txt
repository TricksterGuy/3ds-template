cmake_minimum_required(VERSION 3.7)
project(3DSBuildTemplate)

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES
        source/main.h
        source/main.cpp
        source/graphics/Output.h
        source/graphics/Output.cpp)

add_executable(3DSBuildTemplate ${SOURCE_FILES})

# Specify external includes here
include_directories(C:/Development/3ds-homebrew/devkitPro/devkitARM/include/)
include_directories(C:/Development/3ds-homebrew/devkitPro/devkitARM/arm-none-eabi/include)
include_directories(C:/Development/3ds-homebrew/devkitPro/libctru/include)
include_directories(C:/Development/3ds-homebrew/devkitPro/libjpeg-turbo64/include)
include_directories(C:/Development/3ds-homebrew/devkitPro/portlibs/armv6k/include)
