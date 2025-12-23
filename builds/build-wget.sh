#!/bin/bash
# ======================================================
#  Script Name: build-wget.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build Wget for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf wget-1.25.0.tar.gz
cd wget-1.25.0
###
# build
./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl &&
make
make install
###
cd ..
rm -rf wget-1.25.0
###
popd
