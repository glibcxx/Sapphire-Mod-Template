cmake_policy(SET CMP0169 OLD)

include(FetchContent)

FetchContent_Declare(
    sapphire
    GIT_REPOSITORY https://github.com/glibcxx/Sapphire.git
    GIT_TAG v0.2.2
)

find_package(sapphire QUIET)
if(sapphire_FOUND)
    message(STATUS "Found Sapphire SDK at: ${sapphire_DIR}")
    sapphire_resolve_dependencies()
else()
    message(STATUS "  -> Sapphire SDK not found. Fetching from git...")
    FetchContent_GetProperties(sapphire)
    if(NOT sapphire_POPULATED)
        FetchContent_Populate(sapphire)
        add_subdirectory(${sapphire_SOURCE_DIR} ${sapphire_BINARY_DIR} EXCLUDE_FROM_ALL)
    endif()
    foreach(BUILDING_MC_VERSION ${SAPPHIRE_SUPPORTED_MC_VERSIONS})
        add_library(Sapphire::sapphire_core+mc${BUILDING_MC_VERSION} ALIAS sapphire_core+mc${BUILDING_MC_VERSION})
    endforeach()
endif()

