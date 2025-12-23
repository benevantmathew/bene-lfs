#!/bin/bash
# ======================================================
#  Script Name: build-which.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build which for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf which-2.23.tar.gz
cd which-2.23
###
# BUILD
./configure --prefix=/usr &&
make
make install
###
cd ..
rm -rf which-2.23
###
popd
