set(TARGET llama-cli)
add_executable(${TARGET} main.cpp)
target_link_libraries(${TARGET} PRIVATE common llama ${CMAKE_THREAD_LIBS_INIT})
target_compile_features(${TARGET} PRIVATE cxx_std_17)

if (GGML_CUDA_DEBUG AND GGML_CUDA)
    find_package(CUDAToolkit QUIET)
    if (CUDAToolkit_FOUND)
        # Check if nvToolsExt.h exists
        find_path(NVTOOLSEXT_INCLUDE_DIR nvToolsExt.h
            PATHS
            ${CUDAToolkit_INCLUDE_DIRS}
            ${CUDAToolkit_ROOT_DIR}/include
            ${CUDAToolkit_ROOT_DIR}/targets/x86_64-linux/include
            /usr/local/cuda/include
            /usr/include
        )
        if (NVTOOLSEXT_INCLUDE_DIR)
            target_compile_definitions(${TARGET} PRIVATE GGML_CUDA_NVTX)
            target_include_directories(${TARGET} PRIVATE ${NVTOOLSEXT_INCLUDE_DIR})
            # NVTX3 is header-only, but try to link nvToolsExt if available for older API compatibility
            find_library(NVTOOLSEXT_LIB nvToolsExt 
                PATHS 
                ${CUDAToolkit_LIBRARY_DIR} 
                ${CUDAToolkit_ROOT_DIR}/lib64 
                ${CUDAToolkit_ROOT_DIR}/lib
                ${CUDAToolkit_ROOT_DIR}/targets/x86_64-linux/lib
            )
            if (NVTOOLSEXT_LIB)
                target_link_libraries(${TARGET} PRIVATE ${NVTOOLSEXT_LIB})
            endif()
        endif()
    endif()
endif()

if(LLAMA_TOOLS_INSTALL)
    install(TARGETS ${TARGET} RUNTIME)
endif()
