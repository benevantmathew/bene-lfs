#!/bin/bash
# ======================================================
#  Script Name: build-fastfetch.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build fastfetch for LFS
# ======================================================
set -euo pipefail

# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

FASTFETCH_VER="2.56.1"
STD_FILENAME="fastfetch-${FASTFETCH_VER}.tar.gz"


pushd "$SRC" > /dev/null
###

rm -rf "$SRC/fastfetch-${FASTFETCH_VER}"
tar -xvf "$STD_FILENAME"
cd "fastfetch-${FASTFETCH_VER}"
###
# BUILD
mkdir build &&
cd    build &&

cmake -D CMAKE_INSTALL_PREFIX=/usr    \
    -D CMAKE_BUILD_TYPE=Release     \
    -D BUILD_FLASHFETCH=OFF         \
    -D PACKAGES_DISABLE_CHOCO=ON    \
    -D PACKAGES_DISABLE_MACPORTS=ON \
    -D PACKAGES_DISABLE_SCOOP=ON    \
    -D PACKAGES_DISABLE_WINGET=ON   \
    ..  &&

make

make install

###
rm -rf "$SRC/fastfetch-${FASTFETCH_VER}"

###
popd > /dev/null
