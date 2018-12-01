#!/bin/bash
NDK=$HOME/Android/android-ndk-r10e
SYSROOT=$NDK/platforms/android-19/arch-arm/
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64
function build_one
{

# x264
./configure --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- --sysroot=$SYSROOT --host=arm-linux --disable-asm --enable-pic --enable-static --disable-cli --disable-opencl

# fdk-aac
export ANDROID_ROOT=$NDK/platforms/android-19/arch-arm
export ANDROID_BIN=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin
export CFLAGS="-DANDROID -fPIC -ffunction-sections -funwind-tables -fstack-protector -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300"
export LDFLAGS="-Wl,--fix-cortex-a8"
export CC="arm-linux-androideabi-gcc --sysroot=$ANDROID_ROOT"
export CXX="arm-linux-androideabi-g++ --sysroot=$ANDROID_ROOT"
export PATH=$ANDROID_BIN:$PATH
./configure --host=arm-linux-androideabi  --with-sysroot="$ANDROID_ROOT"  --enable-static --disable-asm --enable-pic --prefix="/home/moonsky219/yt-watchme/app/src/main/sources/fdk-aac-0.1.3/android"

# ffmpeg
./configure --prefix=$PREFIX --enable-shared --enable-static --disable-asm --enable-pic --disable-doc --disable-ffmpeg --disable-ffplay --disable-ffprobe --disable-ffserver --disable-avdevice --disable-doc --disable-symver --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- --target-os=linux --arch=arm --enable-cross-compile --sysroot=$SYSROOT --enable-libx264 --enable-gpl --enable-postproc --enable-avresample --enable-libfdk_aac --enable-nonfree --extra-cflags="-Os -fpic $ADDI_CFLAGS" --extra-ldflags="$ADDI_LDFLAGS" $ADDITIONAL_CONFIGURE_FLAG

make clean
make
make install
}
CPU=arm
PREFIX=$(pwd)/android/$CPU 
ADDI_CFLAGS="-marm -I../x264 -I../fdk-aac-0.1.3/android/include"
ADDI_LDFLAGS="-L../x264 -L../fdk-aac-0.1.3/android/lib"
build_one
