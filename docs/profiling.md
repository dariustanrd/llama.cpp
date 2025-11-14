# Profiling llama.cpp

This document describes how to profile llama.cpp using various profiling tools.

## NVIDIA Nsight Systems (NVTX Profiling)

NVTX (NVIDIA Tools Extension) profiling allows you to profile CUDA applications using NVIDIA Nsight Systems.

### Prerequisites

Add NVTX install args and annotations as per commits `101d5e51bd99320abe3cff544b8764e2eebfb316` and `7b6af97a0273ee68df7144c47416f61c72cc6511`.

### Build with NVTX Support

```bash
cmake -B build-cuda-debug-nvtx -DGGML_CUDA=ON -DGGML_CUDA_DEBUG=ON
cmake --build build-cuda-debug-nvtx -j"$(nproc)"
```

### Profile with nsys

```bash
# Profile llama-cli
nsys profile --sample=cpu --backtrace=dwarf --cuda-graph-trace=node ./llama-cli -m ../../models/gemma-3-270m-it-Q8_0.gguf -p "I believe the meaning of life is" -n 128 -no-cnv

# Profile llama-bench
nsys profile --sample=cpu --backtrace=dwarf --cuda-graph-trace=node ./llama-bench --model ../../models/gemma-3-270m-it-Q8_0.gguf --repetitions 5
```

## Arm Streamline Profiling

Arm Streamline profiling allows you to profile llama.cpp on Arm platforms using Arm Streamline Performance Analyzer.

### Prerequisites

Follow the guide at: https://learn.arm.com/learning-paths/servers-and-cloud-computing/llama_cpp_streamline/3_llama.cpp_annotation/

### Target Setup

#### Setup gator

```bash
git clone https://github.com/ARM-software/gator.git
cd gator
sudo apt-get install ninja-build
./build-linux.sh
cd build-native-gcc-rel/
chmod +x ./gatord
```

#### Setup annotations

```bash
git clone https://github.com/ARM-software/gator.git
cd gator/annotate
cmake -S . -B build
cmake --build build -j"$(nproc)"
cp libstreamline_annotate.a streamline_annotate.h path/to/llama.cpp/streamline_annotation
```

#### Start gator daemon

When ready to profile:
```bash
sudo ./gatord -a
```

### Build llama.cpp with Streamline Support

```bash
cmake -B build-kleidi-debug-streamline \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_EXE_LINKER_FLAGS="-static -g" \
    -DGGML_OPENMP=OFF \
    -DCMAKE_C_FLAGS="-march=native -g" \
    -DCMAKE_CXX_FLAGS="-march=native -g" \
    -DGGML_CPU_KLEIDIAI=ON \
    -DLLAMA_BUILD_TESTS=OFF \
    -DLLAMA_BUILD_EXAMPLES=ON \
    -DLLAMA_CURL=OFF \
    -DARM_STREAMLINE_ANNOTATION=ON
cmake --build build-kleidi-debug-streamline/ -j"$(nproc)"
```

### Using Arm Streamline

1. Select counters and capture settings in Arm Streamline
2. Connect to the target device via SSH
3. Profile from Arm Streamline connected via SSH

### Add Annotations

Refer to the Arm Streamline documentation for details on adding annotations to your code.
