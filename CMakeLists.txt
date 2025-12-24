cmake_minimum_required(VERSION 3.20.0)


set(MOD_PROJECT_NAME "MyMod")
set(MOD_TARGET_NAME "my_mod")
set(MOD_VERSION 1.0.0)
set(MOD_MC_VERSION 1.21.50)


project(${MOD_PROJECT_NAME} VERSION ${MOD_VERSION})

if(NOT MSVC)
    message(FATAL_ERROR "[ERROR] This project requires the MSVC compiler.")
endif()

if(NOT CMAKE_SIZEOF_VOID_P EQUAL 8)
    message(FATAL_ERROR "[ERROR] This project must be compiled for a 64-bit (x64) architecture.")
endif()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# --- 获取 Sapphire SDK ---
include(cmake/FindOrFetchSapphire.cmake)

set(AVAILABLE_MC_VERSIONS ${SAPPHIRE_SUPPORTED_MC_VERSIONS})

if(NOT DEFINED AVAILABLE_MC_VERSIONS)
    message(FATAL_ERROR "Could not determine supported MC versions from the Sapphire SDK.")
else()
    message(STATUS "supported MC versions from the Sapphire SDK: ${AVAILABLE_MC_VERSIONS}")
endif()

if(MOD_MC_VERSION)
    set(DEFAULT_MC_VERSION ${MOD_MC_VERSION})
else()
    list(GET AVAILABLE_MC_VERSIONS 0 DEFAULT_MC_VERSION)
endif()

set(MC_VERSION ${DEFAULT_MC_VERSION})
string(TOLOWER ${MC_VERSION} MC_VERSION)
if(${MC_VERSION} MATCHES "all")
    set(MC_VERSION ${DEFAULT_MC_VERSION})
endif()


list(FIND AVAILABLE_MC_VERSIONS ${MC_VERSION} IS_SUPPORTED)
if(IS_SUPPORTED EQUAL -1)
    message(FATAL_ERROR "The selected MC version '${MC_VERSION}' is not supported by the Sapphire SDK. Please choose from: ${AVAILABLE_MC_VERSIONS}")
endif()

message(STATUS "Building mod for selected Sapphire version: ${MC_VERSION}")

message(STATUS "Mod will be installed at: ${CMAKE_INSTALL_PREFIX}")

set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

file(GLOB_RECURSE MOD_SRC src/*.cpp)

add_library(${MOD_TARGET_NAME} SHARED)
target_sources(${MOD_TARGET_NAME} PRIVATE ${MOD_SRC})

string(REPLACE "." "_" MC_VERSION_MACRO_FORMAT ${MC_VERSION})
target_compile_definitions(${MOD_TARGET_NAME} PRIVATE "MC_VERSION=v${MC_VERSION_MACRO_FORMAT}")

target_link_libraries(${MOD_TARGET_NAME} PRIVATE Sapphire::sapphire_core+mc${MC_VERSION})

sapphire_package_mod(${MOD_TARGET_NAME}
    MANIFEST_TEMPLATE "${CMAKE_CURRENT_SOURCE_DIR}/manifest.json.in"
    INSTALL_PATH "${MOD_PROJECT_NAME}-${MOD_VERSION}+mc${MC_VERSION}"
    MAIN_DLL "${MOD_TARGET_NAME}.dll"
    MC_VERSION_DEP ${MC_VERSION}
)
