# streamline_annotation library

add_library(streamline_addon STATIC
    streamline_addon.cpp
)

target_include_directories(streamline_addon PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/streamline_annotation>
)

target_compile_features(streamline_addon PUBLIC cxx_std_17)

# Link the static library if it exists
set(STREAMLINE_LIB_PATH "${CMAKE_CURRENT_SOURCE_DIR}/libstreamline_annotate.a")
if(EXISTS "${STREAMLINE_LIB_PATH}")
    target_link_libraries(streamline_addon PRIVATE "${STREAMLINE_LIB_PATH}")
endif()

# Install the library and header files
if(ARM_STREAMLINE_INSTALL)
    install(TARGETS streamline_addon
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )
    
    install(FILES streamline_addon.h
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/streamline_annotation
    )
endif()



