#!/bin/bash
# ======================================================
#  Script Name: build-freetype.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build freetype for LFS
# ======================================================
# configure
PHASE=04-system
PKG=freetype

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
rm -rf freetype-2.13.3
tar -xvf freetype-2.13.3.tar.xz
cd freetype-2.13.3
###

# BUILD
sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&
sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&
./configure --prefix=/usr --enable-freetype-config --disable-static &&
make
make install

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf freetype-2.13.3
###
popd
