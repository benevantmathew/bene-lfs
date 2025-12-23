#!/bin/bash
# ======================================================
#  Script Name: build-libunistring.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build libunistring for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf libunistring-1.3.tar.xz
cd libunistring-1.3
###
# BUILD
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libunistring-1.3 &&
make
make install
###
cd ..
rm -rf libunistring-1.3
###
popd
