set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(CMAKE_C_COMPILER   "/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-gcc")
set(CMAKE_CXX_COMPILER "/home/builder/poky-sdk/sysroots/x86_64-oesdk-linux/usr/bin/aarch64-telechips-linux/aarch64-telechips-linux-g++")
set(CMAKE_SYSROOT /home/builder/poky-sdk/sysroots/cortexa55-telechips-linux)


# Standard flags (same as your environment)
set(CMAKE_C_FLAGS   "-mbranch-protection=standard -fstack-protector-strong -fPIE -pie -O2 -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Werror=format-security -fPIC --sysroot=${CMAKE_SYSROOT}")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}")

set(CMAKE_FIND_ROOT_PATH /home/builder/poky-sdk/sysroots/cortexa55-telechips-linux)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)