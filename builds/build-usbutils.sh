#!/bin/bash
# ======================================================
#  Script Name: build-usbutils.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build usbutils for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf usbutils-018.tar.xz
cd usbutils-018
###
# BUILD
mkdir build &&
cd    build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release &&

ninja
ninja install
###
cd ..
rm -rf usbutils-018
###
popd
