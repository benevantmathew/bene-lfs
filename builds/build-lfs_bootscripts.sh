#!/bin/bash
# ======================================================
#  Script Name: build-lfs_bootscripts.sh
#  Author: Benevant Mathew
#  Created: 2025-12-22
#  LFS: 12.4
#  Purpose: Build pkgconf for LFS
# ======================================================
# configure
PHASE=05-config
PKG=lfs_bootscripts

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
rm -rf lfs-bootscripts-20250827
tar -xvf lfs-bootscripts-20250827.tar.xz
cd lfs-bootscripts-20250827
###

# BUILD
make install

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf lfs-bootscripts-20250827
###
popd
