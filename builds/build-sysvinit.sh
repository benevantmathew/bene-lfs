#!/bin/bash
# ======================================================
#  Script Name: build-sysvinit.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build sysvinit for LFS
# ======================================================
# configure
PHASE=04-system
PKG=sysvinit

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
rm -rf sysvinit-3.14
tar -xvf sysvinit-3.14.tar.xz
cd sysvinit-3.14
###

# BUILD
patch -Np1 -i ../sysvinit-3.14-consolidated-1.patch
make
make install

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf sysvinit-3.14
###
popd
