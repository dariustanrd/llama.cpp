set(TARGET llama-cli)
add_executable(${TARGET} main.cpp)
install(TARGETS ${TARGET} RUNTIME)
target_link_libraries(${TARGET} PRIVATE common llama ${CMAKE_THREAD_LIBS_INIT})
target_compile_features(${TARGET} PRIVATE cxx_std_17)

if (GGML_CUDA_DEBUG)
    target_compile_definitions(${TARGET} PRIVATE GGML_CUDA_NVTX)
    # Link nvToolsExt for NVTX support
    find_library(NVTOOLSEXT_LIB nvToolsExt PATHS ${CUDAToolkit_LIBRARY_DIR} ${CUDAToolkit_ROOT_DIR}/lib64 ${CUDAToolkit_ROOT_DIR}/lib)
    if (NVTOOLSEXT_LIB)
        target_link_libraries(${TARGET} PRIVATE ${NVTOOLSEXT_LIB})
    endif()
endif()

if(LLAMA_TOOLS_INSTALL)
    install(TARGETS ${TARGET} RUNTIME)
endif()
