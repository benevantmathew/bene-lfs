#!/bin/bash
# ======================================================
#  Script Name: build-iproute2.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build iproute2 for LFS
# ======================================================
# configure
PHASE=04-system
PKG=iproute2

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
rm -rf iproute2-6.16.0
tar -xvf iproute2-6.16.0.tar.xz
cd iproute2-6.16.0
###

# BUILD
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
make NETNS_RUN_DIR=/run/netns
make SBINDIR=/usr/sbin install
install -vDm644 COPYING README* -t /usr/share/doc/iproute2-6.16.0

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf iproute2-6.16.0
###
popd
