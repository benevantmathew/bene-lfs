#!/bin/bash
# ======================================================
#  Script Name: build-efibootmgr.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build efibootmgr for LFS
# ======================================================
# configure
PHASE=04-system
PKG=efibootmgr

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
rm -rf efibootmgr-18
tar -xvf efibootmgr-18.tar.gz
cd efibootmgr-18
###

# BUILD
make EFIDIR=LFS EFI_LOADER=grubx64.efi
make install EFIDIR=LFS

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf efibootmgr-18
###
popd
