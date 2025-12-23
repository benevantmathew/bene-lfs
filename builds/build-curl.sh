#!/bin/bash
# ======================================================
#  Script Name: build-curl.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build curl for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf curl-8.15.0.tar.xz
cd curl-8.15.0
###
# BUILD
./configure --prefix=/usr    \
            --disable-static \
            --with-openssl   \
            --with-ca-path=/etc/ssl/certs &&
make
make install &&

rm -rf docs/examples/.deps &&

find docs \( -name Makefile\* -o  \
             -name \*.1       -o  \
             -name \*.3       -o  \
             -name CMakeLists.txt \) -delete &&

cp -v -R docs -T /usr/share/doc/curl-8.15.0
###
cd ..
rm -rf curl-8.15.0
###
popd
