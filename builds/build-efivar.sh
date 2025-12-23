#!/bin/bash
# ======================================================
#  Script Name: build-efivar.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build efivar for LFS
# ======================================================
# configure
PHASE=04-system
PKG=efivar

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
rm -rf efivar-39
tar -xvf efivar-39.tar.gz
cd efivar-39
###

# BUILD
make ENABLE_DOCS=0
make install ENABLE_DOCS=0 LIBDIR=/usr/lib
install -vm644 docs/efivar.1 /usr/share/man/man1 &&
install -vm644 docs/*.3      /usr/share/man/man3

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf efivar-39
###
popd
