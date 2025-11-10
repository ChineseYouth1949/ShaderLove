cmake_minimum_required(VERSION 3.30)

project(DirectXLab VERSION 1.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

file(GLOB_RECURSE SRCS
    "${CMAKE_CURRENT_SOURCE_DIR}/Source/*.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/Source/*.cpp")

add_executable(${PROJECT_NAME} ${SRCS})

set(OUTPUT_BASE_DIR "${RUNTIME_ARCHIVE_LIBRARY_BASE_DIRECTORY}")
set_target_properties(${PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${OUTPUT_BASE_DIR}/${PROJECT_NAME}/Bin"
    ARCHIVE_OUTPUT_DIRECTORY "${OUTPUT_BASE_DIR}/${PROJECT_NAME}/Lib"
    LIBRARY_OUTPUT_DIRECTORY "${OUTPUT_BASE_DIR}/${PROJECT_NAME}/Lib"
)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_definitions(${PROJECT_NAME} PUBLIC _DEBUG)
endif()

set_target_properties(${PROJECT_NAME} PROPERTIES WIN32_EXECUTABLE TRUE)

target_include_directories(${PROJECT_NAME} PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/Source/")

target_link_libraries(${PROJECT_NAME} PUBLIC
    d3d12.lib
    dxgi.lib
    d3dcompiler.lib
    dxguid.lib
)

set(AssetsPath "${CMAKE_SOURCE_DIR}/Assets")

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory $<TARGET_FILE_DIR:${PROJECT_NAME}>/Assets
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_SOURCE_DIR}/Assets/
    $<TARGET_FILE_DIR:${PROJECT_NAME}>/Assets/
    COMMENT "Copying Assets/Model directory to output"
    VERBATIM
)