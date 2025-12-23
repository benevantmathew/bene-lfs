#!/bin/bash
# ======================================================
#  Script Name: build-diffutils_pass1.sh
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
tar -xvf diffutils-3.12.tar.xz
cd diffutils-3.12
###

# BUILD
./configure --prefix=/usr   \
    --host=$LFS_TGT \
    gl_cv_func_strcasecmp_works=y \
    --build=$(./build-aux/config.guess)
make
make DESTDIR=$LFS install

###
cd ..
rm -rf diffutils-3.12
###
popd
