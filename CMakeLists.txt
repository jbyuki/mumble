cmake_minimum_required(VERSION 3.1)
set(CMAKE_CXX_STANDARD 11)
project(mumble)

add_executable(mumble
	nlp_utils.cpp
	nlp_utils.h
	main.cpp
)

target_link_libraries(mumble)
