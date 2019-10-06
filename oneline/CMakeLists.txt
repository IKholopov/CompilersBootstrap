cmake_minimum_required(VERSION 3.8)
project(oneline-grammar)

set(CMAKE_CXX_STANDARD 17)
add_compile_options(-Wall -Wno-sign-compare -Wno-overloaded-virtual)

# Flex lexer
find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

add_subdirectory(parser)

