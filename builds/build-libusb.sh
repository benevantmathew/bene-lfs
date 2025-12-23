#!/bin/bash
# ======================================================
#  Script Name: build-libusb.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build libusb for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf libusb-1.0.29.tar.bz2
cd libusb-1.0.29
###
# BUILD
./configure --prefix=/usr --disable-static &&
make
make install
###
cd ..
rm -rf libusb-1.0.29
###
popd
