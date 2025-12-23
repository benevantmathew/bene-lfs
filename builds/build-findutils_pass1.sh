#!/bin/bash
# ======================================================
#  Script Name: build-findutils_pass1.sh
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
tar -xvf findutils-4.10.0.tar.xz
cd findutils-4.10.0
###

# BUILD
./configure --prefix=/usr                   \
    --localstatedir=/var/lib/locate \
    --host=$LFS_TGT                 \
    --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

###
cd ..
rm -rf findutils-4.10.0
###
popd
