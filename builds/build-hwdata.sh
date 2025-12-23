#!/bin/bash
# ======================================================
#  Script Name: build-hwdata.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build hwdata for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf hwdata-0.398.tar.gz
cd hwdata-0.398
###
# BUILD
./configure --prefix=/usr --disable-blacklist
make install
###
cd ..
rm -rf hwdata-0.398
###
popd
