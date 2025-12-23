#!/bin/bash
# ======================================================
#  Script Name: build-libidn2.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build libidn2 for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf libidn2-2.3.8.tar.gz
cd libidn2-2.3.8
###
# BUILD
./configure --prefix=/usr --disable-static &&
make
make install
###
cd ..
rm -rf libidn2-2.3.8
###
popd
