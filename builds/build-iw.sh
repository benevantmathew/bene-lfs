#!/bin/bash
# ======================================================
#  Script Name: build-iw.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build iw for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf iw-6.9.tar.xz
cd iw-6.9
###
sed -i "/INSTALL.*gz/s/.gz//" Makefile &&
make
make install
###
cd ..
rm -rf iw-6.9
###
popd
