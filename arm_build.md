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

--> this works to build kleidi AI with llama.cpp! note that kernels.cpp and kleidiai.cpp were also modified in /workspace/llama.cpp/ggml/src/ggml-cpu/kleidiai/kernels.cpp based on https://github.com/ggml-org/llama.cpp/pull/14700/files, to fix /workspace/llama.cpp/ggml/src/ggml-cpu/kleidiai/kernels.cpp:113:30: error: zero-size array ‘gemm_gemv_kernels’ 113 | static ggml_kleidiai_kernels gemm_gemv_kernels[] = 
--> with this build, take build/bin and copy libgomp.so.1 into that folder, then can run on device.