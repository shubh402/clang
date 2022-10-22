#!/usr/bin/env bash

echo "******************************"
echo "* Building Bleeding Edge GCC *"
echo "******************************"

export PREFIX="$HOME/opt/cross"
export TARGET=aarch64-elf
export PATH="$PREFIX/bin:$PATH"

download_resources () {
    echo "Downloading Pre-requisites"
    git clone git://sourceware.org/git/binutils-gdb.git -b master binutils --depth=1
    git clone https://git.linaro.org/toolchain/gcc.git -b master gcc --depth=1
}

build_binutils () {
    echo "Building Binutils"
    mkdir build-binutils
    cd build-binutils
    ../binutils/configure --target=$TARGET \
                          --prefix="$PREFIX" \
                          --with-sysroot \
                          --disable-nls \
                          --disable-werror
    make -j8
    make install -j8
    cd ../
}

build_gcc () {
    echo "Building GCC"
    mkdir build-gcc
    cd build-gcc
    ../gcc/configure --target=$TARGET \
                     --prefix="$PREFIX" \
                     --disable-nls \
                     --enable-languages=c,c++ \
                     --without-headers
    make all-gcc -j8
    make all-target-libgcc -j8
    make install-gcc -j8
    make install-target-libgcc -j8
}

download_resources
build_binutils
build_gcc
