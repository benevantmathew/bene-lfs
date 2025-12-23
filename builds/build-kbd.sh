#!/bin/bash
# ======================================================
#  Script Name: build-kbd.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build kbd for LFS
# ======================================================
# configure
PHASE=04-system
PKG=kbd

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
rm -rf kbd-2.8.0
tar -xvf kbd-2.8.0.tar.xz
cd kbd-2.8.0
###

# BUILD
patch -Np1 -i ../kbd-2.8.0-backspace-1.patch
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
./configure --prefix=/usr --disable-vlock
make
make install
cp -R -v docs/doc -T /usr/share/doc/kbd-2.8.0

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf kbd-2.8.0
###
popd
