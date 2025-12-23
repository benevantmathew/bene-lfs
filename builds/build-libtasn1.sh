#!/bin/bash
# ======================================================
#  Script Name: build-libtasn1.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build libtasn1 for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf libtasn1-4.20.0.tar.gz
cd libtasn1-4.20.0
###
# BUILD
./configure --prefix=/usr --disable-static &&
make
make install
###
cd ..
rm -rf libtasn1-4.20.0
###
popd
