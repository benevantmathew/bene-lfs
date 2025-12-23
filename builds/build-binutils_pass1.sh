#!/bin/bash
# ======================================================
#  Script Name: build-binutils_pass1.sh
#  Author: Benevant Mathew
#  Created: 2025-12-14
#  LFS: 12.4
#  Purpose: Build Binutils for Tool Chain
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

if [ ! -d "$LFS" ]; then
    echo "Error: LFS variable $LFS does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf binutils-2.45.tar.xz
cd binutils-2.45
###
# BUILD
mkdir -v build
cd       build
../configure --prefix=$LFS/tools \
    --with-sysroot=$LFS \
    --target=$LFS_TGT   \
    --disable-nls       \
    --enable-gprofng=no \
    --disable-werror    \
    --enable-new-dtags  \
    --enable-default-hash-style=gnu
make && make install
###
cd ../..
rm -rf binutils-2.45
###
popd
