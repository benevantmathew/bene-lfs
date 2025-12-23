#!/bin/bash
# ======================================================
#  Script Name: build-texinfo_pass1.sh
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
tar -xvf texinfo-7.2.tar.xz
cd texinfo-7.2
###

# BUILD
./configure --prefix=/usr
make
make install

###
cd ..
rm -rf texinfo-7.2
###
popd
