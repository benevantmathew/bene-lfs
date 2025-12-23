#!/bin/bash
# ======================================================
#  Script Name: build-bison_pass1.sh
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
tar -xvf bison-3.8.2.tar.xz
cd bison-3.8.2
###

# BUILD
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2
make
make install

###
cd ..
rm -rf bison-3.8.2
###
popd
