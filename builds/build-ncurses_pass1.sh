#!/bin/bash
# ======================================================
#  Script Name: build-binutils_pass1.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
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
tar -xvf ncurses-6.5-20250809.tgz
cd ncurses-6.5-20250809/
###

# BUILD
mkdir build
pushd build
../configure --prefix=$LFS/tools AWK=gawk
make -C include
make -C progs tic
install progs/tic $LFS/tools/bin
popd
./configure --prefix=/usr \
    --host=$LFS_TGT \
    --build=$(./config.guess) \
    --mandir=/usr/share/man \
    --with-manpage-format=normal \
    --with-shared \
    --without-normal \
    --with-cxx-shared \
    --without-debug \
    --without-ada \
    --disable-stripping \
    AWK=gawk
make
make DESTDIR=$LFS install
ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i $LFS/usr/include/curses.h

###
cd ..
rm -rf ncurses-6.5-20250809/
###
popd
