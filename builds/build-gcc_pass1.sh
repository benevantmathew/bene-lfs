#!/bin/bash
# ======================================================
#  Script Name: build-gcc_pass1.sh
#  Author: Benevant Mathew
#  Created: 2025-12-14
#  LFS: 12.4
#  Purpose: Build GCC for Tool Chain
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
cd gcc-15.2.0
tar -xf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc
###
# BUILD
case $(uname -m) in
    x86_64)
    sed -e '/m64=/s/lib64/lib/' \
    -i.orig gcc/config/i386/t-linux64
    ;;
esac
mkdir -v build && cd build
    ../configure \
    --target=$LFS_TGT \
    --prefix=$LFS/tools \
    --with-glibc-version=2.42 \
    --with-sysroot=$LFS \
    --with-newlib \
    --without-headers \
    --enable-default-pie \
    --enable-default-ssp \
    --disable-nls \
    --disable-shared \
    --disable-multilib \
    --disable-threads \
    --disable-libatomic \
    --disable-libgomp \
    --disable-libquadmath \
    --disable-libssp \
    --disable-libvtv \
    --disable-libstdcxx \
    --enable-languages=c,c++
make && make install
###
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
    `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h
cd ..
rm -rf gcc-15.2.0
###
popd
