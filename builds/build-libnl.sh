#!/bin/bash
# ======================================================
#  Script Name: build-libnl.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build libnl for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf libnl-3.11.0.tar.gz
cd libnl-3.11.0
###
# BUILD
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make
make install
###
cd ..
rm -rf libnl-3.11.0
###
popd
