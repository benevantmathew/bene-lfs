#!/bin/bash
# ======================================================
#  Script Name: build-perl_pass1.sh
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

pushd "$SRC"
###
tar -xvf Python-3.13.7.tar.xz
cd Python-3.13.7
###

# BUILD
./configure --prefix=/usr       \
            --enable-shared     \
            --without-ensurepip \
            --without-static-libpython
make
make install

###
cd ..
rm -rf Python-3.13.7
###
popd
