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
tar -xvf bash-5.3.tar.gz
cd bash-5.3
###

# BUILD
./configure --prefix=/usr \
    --build=$(sh support/config.guess) \
    --host=$LFS_TGT \
    --without-bash-malloc
make
make DESTDIR=$LFS install
ln -sv bash $LFS/bin/sh

###
cd ..
rm -rf bash-5.3
###
popd
