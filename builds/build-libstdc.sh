#!/bin/bash
# ======================================================
#  Script Name: build-libstdc.sh
#  Author: Benevant Mathew
#  Created: 2025-12-14
#  LFS: 12.4
#  Purpose: Build libstdc for Tool Chain
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
tar -xvf gcc-15.2.0.tar.xz
cd gcc-15.2.0/
###
# BUILD
mkdir -v build
cd build
../libstdc++-v3/configure \
    --host=$LFS_TGT \
    --build=$(../config.guess) \
    --prefix=/usr \
    --disable-multilib \
    --disable-nls \
    --disable-libstdcxx-pch \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/15.2.0
make
make DESTDIR=$LFS install
rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la
###
cd ../..
rm -rf gcc-15.2.0
###
popd
