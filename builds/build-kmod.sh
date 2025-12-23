#!/bin/bash
# ======================================================
#  Script Name: build-kmod.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build kmod for LFS
# ======================================================
# configure
PHASE=04-system
PKG=kmod

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
rm -rf kmod-34.2
tar -xvf kmod-34.2.tar.xz
cd kmod-34.2
###

# BUILD
mkdir -p build
cd       build
meson setup --prefix=/usr ..    \
            --buildtype=release \
            -D manpages=false
ninja
ninja install

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ../..
rm -rf kmod-34.2
###
popd
