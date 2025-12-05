in an aarch64 docker container env (e.g. tvm-builder-aarch64)

apt install -y software-properties-common curl libssl-dev libcurl4-openssl-dev
add-apt-repository ppa:ubuntu-toolchain-r/test
apt install -y gcc-11 g++-11
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100

https://github.com/ggml-org/llama.cpp/blob/5aa1105da24a8dd1661cea3db0582c9b2c2f54d3/docs/build.md

cmake -B build -DGGML_CPU_KLEIDIAI=ON --> fails

cmake -B build -DGGML_NATIVE=ON -DGGML_CPU_AARCH64=ON -DGGML_CPU_KLEIDIAI=ON --> fails

cmake -B build -DGGML_CPU_AARCH64=ON -DGGML_CPU_KLEIDIAI=ON --> fails

cmake -B build -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF
cmake --build build --config Release -j 8

---

apt install crossbuild-essential-arm64 
    # https://github.com/ARM-software/armnn/issues/367

export CXX=aarch64-linux-gnu-g++
export CC=aarch64-linux-gnu-gcc
cmake -B build -DGGML_CPU_KLEIDIAI=ON -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF

cmake -B build -DGGML_BACKEND_DL=ON -DGGML_NATIVE=OFF -DGGML_CPU_KLEIDIAI=ON -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF

cmake -B build -DGGML_BACKEND_DL=ON -DGGML_NATIVE=OFF -DGGML_CPU_ALL_VARIANTS=ON -DGGML_CPU_KLEIDIAI=ON -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF

cmake -B build -DGGML_BACKEND_DL=ON -DGGML_NATIVE=OFF -DGGML_CPU_ARM_ARCH=armv8-a -DGGML_CPU_KLEIDIAI=ON -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF

cmake -B build -DGGML_SYSTEM_ARCH=ARM -DGGML_NATIVE=OFF -DGGML_CPU_ARM_ARCH=armv8-a -DGGML_CPU_KLEIDIAI=ON -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF

cmake -B build -DGGML_SYSTEM_ARCH=ARM -DGGML_NATIVE=OFF -DGGML_CPU_ARM_ARCH=armv8-a -DGGML_SSE42=OFF -DGGML_F16C=OFF -DGGML_FMA=OFF -DGGML_BMI2=OFF -DGGML_AVX=OFF -DGGML_AVX2=OFF -DGGML_CPU_KLEIDIAI=ON -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF

---

cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/aarch64-linux-gnu.cmake \
  -DCMAKE_C_COMPILER=/usr/bin/aarch64-linux-gnu-gcc-11 \
  -DCMAKE_CXX_COMPILER=/usr/bin/aarch64-linux-gnu-g++-11 \
  -DCMAKE_BUILD_TYPE=Release \
  -DGGML_NATIVE=OFF \
  -DGGML_CPU_AARCH64=ON \
  -DGGML_CPU_ARM_ARCH=armv8-a \
  -DGGML_CPU_KLEIDIAI=ON \
  -DLLAMA_CURL=OFF
cmake --build build -j"$(nproc)"

---
# from https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads

wget https://developer.arm.com/-/media/Files/downloads/gnu/11.2-2022.02/binrel/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu.tar.xz
tar -xf gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu.tar.xz
rm gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu.tar.xz


export ARMTC=/opt/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu
export CXX=$ARMTC/bin/aarch64-none-linux-gnu-g++
export CC=$ARMTC/bin/aarch64-none-linux-gnu-gcc
cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/aarch64-linux-gnu.cmake \
  -DCMAKE_C_COMPILER=$ARMTC/bin/aarch64-none-linux-gnu-gcc \
  -DCMAKE_CXX_COMPILER=$ARMTC/bin/aarch64-none-linux-gnu-g++ \
  -DGGML_SYSTEM_ARCH=ARM -DGGML_NATIVE=OFF -DGGML_CPU_ARM_ARCH=armv8-a -DGGML_SSE42=OFF -DGGML_F16C=OFF -DGGML_FMA=OFF -DGGML_BMI2=OFF -DGGML_AVX=OFF -DGGML_AVX2=OFF -DGGML_CPU_KLEIDIAI=ON -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF -DCMAKE_BUILD_TYPE=Release


---

export ARMTC=/opt/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu
export CXX=$ARMTC/bin/aarch64-none-linux-gnu-g++
export CC=$ARMTC/bin/aarch64-none-linux-gnu-gcc
cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/aarch64-linux-gnu.cmake \
  -DCMAKE_C_COMPILER=$ARMTC/bin/aarch64-none-linux-gnu-gcc \
  -DCMAKE_CXX_COMPILER=$ARMTC/bin/aarch64-none-linux-gnu-g++ \
  -DCMAKE_SYSROOT=$ARMTC/aarch64-none-linux-gnu/libc \
  -DGGML_OPENMP=ON \
  -DCMAKE_EXE_LINKER_FLAGS="-fopenmp -Wl,--no-as-needed" \
  -DCMAKE_SHARED_LINKER_FLAGS="-fopenmp -Wl,--no-as-needed" \
  -DGGML_SYSTEM_ARCH=ARM -DGGML_NATIVE=OFF -DGGML_CPU_ARM_ARCH=armv8-a -DGGML_SSE42=OFF -DGGML_F16C=OFF -DGGML_FMA=OFF -DGGML_BMI2=OFF -DGGML_AVX=OFF -DGGML_AVX2=OFF -DGGML_CPU_KLEIDIAI=ON -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"

--> this works to build kleidi AI with llama.cpp! note that kernels.cpp and kleidiai.cpp were also modified in /workspace/llama.cpp/ggml/src/ggml-cpu/kleidiai/kernels.cpp based on https://github.com/ggml-org/llama.cpp/pull/14700/files, to fix /workspace/llama.cpp/ggml/src/ggml-cpu/kleidiai/kernels.cpp:113:30: error: zero-size array ‘gemm_gemv_kernels’ 113 | static ggml_kleidiai_kernels gemm_gemv_kernels[] = 
--> with this build, take build/bin and copy libgomp.so.1 into that folder, then can run on device.


---

# yocto build. see yocto_build.md, activate environment 

then:

## kleidi CPU build
/opt/cmake-3.27.9/bin/cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/aarch64-linux-yocto.cmake \
  -DCMAKE_C_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-gcc \
  -DCMAKE_CXX_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-g++ \
  -DCMAKE_SYSROOT=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux \
  -DGGML_OPENMP=ON \
  -DCMAKE_EXE_LINKER_FLAGS="-fopenmp -Wl,--no-as-needed" \
  -DCMAKE_SHARED_LINKER_FLAGS="-fopenmp -Wl,--no-as-needed" \
  -DGGML_SYSTEM_ARCH=ARM -DGGML_NATIVE=OFF -DGGML_CPU_ARM_ARCH=armv8-a -DGGML_SSE42=OFF -DGGML_F16C=OFF -DGGML_FMA=OFF -DGGML_BMI2=OFF -DGGML_AVX=OFF -DGGML_AVX2=OFF -DGGML_CPU_KLEIDIAI=ON -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"

## kleidi CPU + Vulkan build

use newer version of vulkan sdk in order to get dot product working

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
/opt/cmake-3.27.9/bin/cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/aarch64-linux-yocto.cmake \
  -DCMAKE_C_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-gcc \
  -DCMAKE_CXX_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-g++ \
  -DCMAKE_SYSROOT=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux \
  -DGGML_OPENMP=ON \
  -DCMAKE_EXE_LINKER_FLAGS="-fopenmp -Wl,--no-as-needed" \
  -DCMAKE_SHARED_LINKER_FLAGS="-fopenmp -Wl,--no-as-needed" \
  -DGGML_VULKAN=ON \
  -DVulkan_INCLUDE_DIR="$VULKAN_SDK/include" \
  -DVulkan_LIBRARY=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux/usr/lib/libvulkan.so \
  -DVulkan_GLSLC_EXECUTABLE=$GLSLC \
  -DGGML_SYSTEM_ARCH=ARM -DGGML_NATIVE=OFF -DGGML_CPU_ARM_ARCH=armv8-a -DGGML_SSE42=OFF -DGGML_F16C=OFF -DGGML_FMA=OFF -DGGML_BMI2=OFF -DGGML_AVX=OFF -DGGML_AVX2=OFF -DGGML_CPU_KLEIDIAI=ON -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"

---

## Vulkan only
export VULKAN_SDK=/opt/vulkansdk/1.4.328.1/x86_64
export PATH="$VULKAN_SDK/bin:$PATH"
glslc --version
export GLSLC=$(command -v glslc)
/opt/cmake-3.27.9/bin/cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/aarch64-linux-yocto.cmake \
  -DCMAKE_C_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-gcc \
  -DCMAKE_CXX_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-g++ \
  -DCMAKE_SYSROOT=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux \
  -DGGML_OPENMP=ON \
  -DCMAKE_EXE_LINKER_FLAGS="-fopenmp -Wl,--no-as-needed" \
  -DCMAKE_SHARED_LINKER_FLAGS="-fopenmp -Wl,--no-as-needed" \
  -DGGML_VULKAN=ON \
  -DVulkan_INCLUDE_DIR="$VULKAN_SDK/include" \
  -DVulkan_LIBRARY=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux/usr/lib/libvulkan.so \
  -DVulkan_GLSLC_EXECUTABLE=$GLSLC \
  -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"

## CPU only
/opt/cmake-3.27.9/bin/cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/aarch64-linux-yocto.cmake \
  -DCMAKE_C_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-gcc \
  -DCMAKE_CXX_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-g++ \
  -DCMAKE_SYSROOT=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux \
  -DGGML_OPENMP=ON \
  -DCMAKE_EXE_LINKER_FLAGS="-fopenmp -Wl,--no-as-needed" \
  -DCMAKE_SHARED_LINKER_FLAGS="-fopenmp -Wl,--no-as-needed" \
  -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"

## CPU only (no OpenMP)
/opt/cmake-3.27.9/bin/cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/aarch64-linux-yocto.cmake \
  -DCMAKE_C_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-gcc \
  -DCMAKE_CXX_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-g++ \
  -DCMAKE_SYSROOT=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux \
  -DGGML_OPENMP=OFF \
  -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"

## KleidiAI CPU (no OpenMP)
/opt/cmake-3.27.9/bin/cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/aarch64-linux-yocto.cmake \
  -DCMAKE_C_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-gcc \
  -DCMAKE_CXX_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-g++ \
  -DCMAKE_SYSROOT=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux \
  -DGGML_OPENMP=OFF \
  -DGGML_SYSTEM_ARCH=ARM -DGGML_NATIVE=OFF -DGGML_CPU_ARM_ARCH=armv8-a -DGGML_SSE42=OFF -DGGML_F16C=OFF -DGGML_FMA=OFF -DGGML_BMI2=OFF -DGGML_AVX=OFF -DGGML_AVX2=OFF -DGGML_CPU_KLEIDIAI=ON -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"

## Vulkan only (no OpenMP)
export VULKAN_SDK=/opt/vulkansdk/1.4.328.1/x86_64
export PATH="$VULKAN_SDK/bin:$PATH"
glslc --version
export GLSLC=$(command -v glslc)
/opt/cmake-3.27.9/bin/cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/aarch64-linux-yocto.cmake \
  -DCMAKE_C_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-gcc \
  -DCMAKE_CXX_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-g++ \
  -DCMAKE_SYSROOT=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux \
  -DGGML_OPENMP=OFF \
  -DGGML_VULKAN=ON \
  -DVulkan_INCLUDE_DIR="$VULKAN_SDK/include" \
  -DVulkan_LIBRARY=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux/usr/lib/libvulkan.so \
  -DVulkan_GLSLC_EXECUTABLE=$GLSLC \
  -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"

## Kleidi + Vulkan (no OpenMP)
/opt/cmake-3.27.9/bin/cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/aarch64-linux-yocto.cmake \
  -DCMAKE_C_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-gcc \
  -DCMAKE_CXX_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-g++ \
  -DCMAKE_SYSROOT=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux \
  -DGGML_OPENMP=OFF \
  -DGGML_VULKAN=ON \
  -DVulkan_INCLUDE_DIR="$VULKAN_SDK/include" \
  -DVulkan_LIBRARY=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux/usr/lib/libvulkan.so \
  -DVulkan_GLSLC_EXECUTABLE=$GLSLC \
  -DGGML_SYSTEM_ARCH=ARM -DGGML_NATIVE=OFF -DGGML_CPU_ARM_ARCH=armv8-a -DGGML_SSE42=OFF -DGGML_F16C=OFF -DGGML_FMA=OFF -DGGML_BMI2=OFF -DGGML_AVX=OFF -DGGML_AVX2=OFF -DGGML_CPU_KLEIDIAI=ON -DGGML_CPU_AARCH64=ON -DLLAMA_CURL=OFF -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"

## Try fix kleidi CPU build
/opt/cmake-3.27.9/bin/cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/aarch64-linux-yocto.cmake \
  -DCMAKE_C_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-gcc \
  -DCMAKE_CXX_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-g++ \
  -DCMAKE_SYSROOT=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux \
  -DGGML_OPENMP=ON \
  -DCMAKE_EXE_LINKER_FLAGS="-fopenmp -Wl,--no-as-needed" \
  -DCMAKE_SHARED_LINKER_FLAGS="-fopenmp -Wl,--no-as-needed" \
  -DGGML_SYSTEM_ARCH=ARM \
  -DGGML_NATIVE=OFF \
  -DGGML_CPU_ARM_ARCH=armv8-a \
  -DGGML_SSE42=OFF \
  -DGGML_F16C=OFF \
  -DGGML_FMA=OFF \
  -DGGML_BMI2=OFF \
  -DGGML_AVX=OFF \
  -DGGML_AVX2=OFF \
  -DGGML_CPU_KLEIDIAI=ON \
  -DGGML_CPU_AARCH64=ON \
  -DLLAMA_CURL=OFF \
  -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"

## Try no accel build
/opt/cmake-3.27.9/bin/cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/aarch64-linux-yocto.cmake \
  -DCMAKE_C_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-gcc \
  -DCMAKE_CXX_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-g++ \
  -DCMAKE_SYSROOT=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux \
  -DGGML_OPENMP=OFF \
  -DGGML_SYSTEM_ARCH=ARM \
  -DGGML_NATIVE=OFF \
  -DGGML_CPU_ARM_ARCH=armv8-a \
  -DGGML_CPU_AARCH64=ON \
  -DLLAMA_CURL=OFF \
  -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"

## Try openmp only build, with all variants, try enable other arm features like dotprod, fp16. see llama.cpp/ggml/src/ggml-cpu/CMakeLists.txt
/opt/cmake-3.27.9/bin/cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/aarch64-linux-yocto.cmake \
  -DCMAKE_C_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-gcc \
  -DCMAKE_CXX_COMPILER=/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-g++ \
  -DCMAKE_SYSROOT=/home/builder/poky-sdk/sysroots/cortexa55-telechips-linux \
  -DGGML_OPENMP=ON \
  -DCMAKE_EXE_LINKER_FLAGS="-fopenmp -Wl,--no-as-needed" \
  -DCMAKE_SHARED_LINKER_FLAGS="-fopenmp -Wl,--no-as-needed" \
  -DGGML_SYSTEM_ARCH=ARM \
  -DGGML_NATIVE=OFF \
  -DGGML_CPU_ALL_VARIANTS=ON \
  -DGGML_BACKEND_DL=ON \
  -DGGML_CPU_AARCH64=ON \
  -DLLAMA_CURL=OFF \
  -DCMAKE_BUILD_TYPE=Release

cmake --build build -j"$(nproc)"

## Try manual define, i8mm? fpmm? https://developer.arm.com/documentation/101754/0624/armclang-Reference/Other-Compiler-specific-Features/Supported-architecture-features/Matrix-Multiplication-extension

