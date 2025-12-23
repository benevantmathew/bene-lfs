#!/bin/bash
# ======================================================
#  Script Name: build-libuv.sh
#  Author: Benevant Mathew
#  Created: 2025-12-23
#  LFS: 12.4
#  Purpose: Build libuv for LFS
# ======================================================
set -euo pipefail

# configure
PHASE=blfs
PKG=libuv

# ======================================================
# stamp block
STAMP_ROOT=/stamps
STAMP_DIR="$STAMP_ROOT/$PHASE"
STAMP="$STAMP_DIR/$PKG.done"


[ -f "$STAMP" ] && {
    echo "$PKG already installed — skipping"
    exit 0
}
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

[ "$(id -u)" -eq 0 ] || {
    echo "ERROR: $PKG must be built as root inside chroot" >&2
    exit 1
}

pushd "$SRC"
###
rm -rf libuv-v1.51.0
tar -xvf libuv-v1.51.0.tar.gz
cd libuv-v1.51.0
###

# BUILD
sh autogen.sh                              &&
./configure --prefix=/usr --disable-static &&
make 

make install

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf libuv-v1.51.0
###
popd
