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
tar -xvf glibc-2.42.tar.xz
cd glibc-2.42/
###
# BUILD
case $(uname -m) in
    i?86) ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
    ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac
patch -Np1 -i ../glibc-2.42-fhs-1.patch
mkdir -v build
cd build
echo "rootsbindir=/usr/sbin" > configparms
../configure \
    --prefix=/usr \
    --host=$LFS_TGT \
    --build=$(../scripts/config.guess) \
    --disable-nscd \
    libc_cv_slibdir=/usr/lib \
    --enable-kernel=5
make
make DESTDIR=$LFS install
sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
# Tests
echo 'int main(){}' | $LFS_TGT-gcc -x c - -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
grep -E -o "$LFS/lib.*/S?crt[1in].*succeeded" dummy.log
grep -B3 "^ $LFS/usr/include" dummy.log
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
grep "/lib.*/libc.so.6 " dummy.log
grep found dummy.log
rm -v a.out dummy.log
###
cd ../..
rm -rf glibc-2.42
###
popd
