# Tell CMake this is a cross-compile targeting Linux on AArch64
set(CMAKE_SYSTEM_NAME Linux)
# Use a value ggml recognizes; either "aarch64" or "arm64" is fine.
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(CMAKE_CROSSCOMPILING   TRUE)

# Cross compilers
set(CMAKE_C_COMPILER   /opt/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER /opt/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-g++)

# Point CMake’s find_* to the cross sysroot
# Adjust these paths to your distro if needed.
# set(CMAKE_SYSROOT /usr/aarch64-linux-gnu)
# set(CMAKE_FIND_ROOT_PATH /usr/aarch64-linux-gnu /usr/lib/aarch64-linux-gnu)

# Usual cross-compile find modes
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Avoid try-run during compiler checks when cross-compiling
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
