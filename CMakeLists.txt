cmake_minimum_required(VERSION 3.25)
project(ImageConverter)

set(CMAKE_CXX_STANDARD 17)
set(name "ImageConverter")

set(source_files
	src/converter.cpp
)

add_subdirectory(external/libwebp)

# if(WIN32)
#     add_executable(${name} ${source_files})
# else()
#     add_executable(${name} ${source_files})
# endif()
add_executable(${name} ${source_files})


target_link_libraries(${name} PRIVATE webp)

target_include_directories(${name} PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    external/libwebp/include
)

set_target_properties(${name} PROPERTIES OUTPUT_NAME "converter")