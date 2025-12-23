#!/bin/bash
# ======================================================
#  Script Name: build-linux_headers.sh
#  Author: Benevant Mathew
#  Created: 2025-12-14
#  LFS: 12.4
#  Purpose: Build Linux Headers for Tool Chain
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
tar -xvf linux-6.16.1.tar.xz
cd linux-6.16.1
###
# BUILD
make mrproper
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr
###
cd ..
rm -rf linux-6.16.1
###
popd
