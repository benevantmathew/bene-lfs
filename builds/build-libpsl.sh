#!/bin/bash
# ======================================================
#  Script Name: build-libpsl.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build libpsl for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf libpsl-0.21.5.tar.gz
cd libpsl-0.21.5
###
# BUILD
mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release &&

ninja
ninja install
###
cd ..
rm -rf libpsl-0.21.5
###
popd
