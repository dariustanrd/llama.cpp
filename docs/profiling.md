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

##### For X86:

```bash
cd gator/annotate

source /home/builder/linux-sdk/build-autolinux/buildtools/4.0/environment-setup-x86_64-pokysdk-linux


cmake -S . -B build
cmake --build build -j"$(nproc)"
cp libstreamline_annotate.a streamline_annotate.h path/to/llama.cpp/streamline_annotation
```

##### For Arm:

```bash
source /home/builder/linux-sdk/build-autolinux/buildtools/4.0/environment-setup-x86_64-pokysdk-linux
cmake -S . -B build-aarch64 \
    -DCMAKE_C_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-gcc \
    -DCMAKE_CXX_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-g++ \
    -DCMAKE_SYSROOT=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux \
cmake --build build-aarch64 -j"$(nproc)
cp build-aarch64/libstreamline_annotate.a /workspace/llama.cpp/streamline_annotation/
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

#### For arm build (kleidi + vulkan)
```bash
bitbake telechips-ivi-subcore-image -c populate_sdk
builder@conti-sym7870:~/linux-sdk/build-autolinux/build/tcc8070-sub$ echo $HOME
/home/builder
builder@conti-sym7870:~/linux-sdk/build-autolinux/build/tcc8070-sub$ mkdir -p "$HOME/poky-sdk"
builder@conti-sym7870:~/linux-sdk/build-autolinux/build/tcc8070-sub$ ./tmp/deploy/sdk/poky-telechips-systemd-glibc-x86_64-telechips-ivi-subcore-image-cortexa55-toolchain-nodistro.0.sh 
Telechips Baseline (Poky/meta-telechips/meta-core) SDK installer version nodistro.0
===================================================================================
Enter target directory for SDK (default: /usr/local/oecore-x86_64): /home/builder/poky-sdk         
You are about to install the SDK to "/home/builder/poky-sdk". Proceed [Y/n]? y
Extracting SDK...........................................................done
Setting it up...done
SDK has been successfully set up and is ready to be used.
Each time you wish to use the SDK in a new shell session, you need to source the environment setup script e.g.
 $ . /home/builder/poky-sdk/environment-setup-cortexa55-telechips-linux
```

cd llama.cpp


`source /home/builder/poky-sdk/environment-setup-cortexa55-telechips-linux`
cd /opt
wget https://sdk.lunarg.com/sdk/download/1.4.328.1/linux/vulkansdk-linux-x86_64-1.4.328.1.tar.xz
tar -xf vulkansdk-linux-x86_64-1.4.328.1.tar.xz
rm vulkansdk-linux-x86_64-1.4.328.1.tar.xz
mkdir vulkansdk
mv 1.4.328.1/ ./vulkansdk/1.4.328.1
apt install qt5-default libxcb-xinput0 libxcb-xinerama0

export VULKAN_SDK=/opt/vulkansdk/1.4.328.1/x86_64
export PATH="$VULKAN_SDK/bin:$PATH"
glslc --version

export GLSLC=$(command -v glslc)
/opt/cmake-3.27.9/bin/cmake -S . -B build-kleidi-vulkan-openmp-streamline \
    -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/aarch64-linux-yocto.cmake \
    -DCMAKE_C_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-gcc \
    -DCMAKE_CXX_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-g++ \
    -DCMAKE_SYSROOT=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux \
    -DGGML_OPENMP=ON \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_EXE_LINKER_FLAGS="-fopenmp -Wl,--no-as-needed" \
    -DCMAKE_SHARED_LINKER_FLAGS="-fopenmp -Wl,--no-as-needed" \
    -DLLAMA_BUILD_TESTS=OFF \
    -DLLAMA_BUILD_EXAMPLES=ON \
    -DGGML_VULKAN=ON \
    -DVulkan_INCLUDE_DIR="$VULKAN_SDK/include" \
    -DVulkan_LIBRARY=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux/usr/lib/libvulkan.so \
    -DVulkan_GLSLC_EXECUTABLE=$GLSLC \
    -DGGML_SYSTEM_ARCH=ARM -DGGML_NATIVE=OFF -DGGML_CPU_ARM_ARCH=armv8-a -DGGML_SSE42=OFF -DGGML_F16C=OFF -DGGML_FMA=OFF -DGGML_BMI2=OFF -DGGML_AVX=OFF -DGGML_AVX2=OFF -DGGML_CPU_KLEIDIAI=ON -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF -DCMAKE_BUILD_TYPE=Release \
    -DARM_STREAMLINE_ANNOTATION=ON
cmake --build build-kleidi-vulkan-openmp-streamline/ -j"$(nproc)"
```

### Using Arm Streamline

1. Select counters and capture settings in Arm Streamline
2. Connect to the target device via SSH
3. Profile from Arm Streamline connected via SSH

### Add Annotations

Refer to the Arm Streamline documentation for details on adding annotations to your code.
