#!/bin/bash
# ======================================================
#  Script Name: build-cmake.sh
#  Author: Benevant Mathew
#  Created: 2025-12-23
#  LFS: 12.4
#  Purpose: Build cmake for LFS
# ======================================================
set -euo pipefail

# configure
PHASE=blfs
PKG=cmake

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
rm -rf cmake-4.1.0
tar -xvf cmake-4.1.0.tar.gz
cd cmake-4.1.0
###

# BUILD
sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake &&

./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-cppdap   \
            --no-system-librhash \
            --docdir=/share/doc/cmake-4.1.0 &&
make

make install

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf cmake-4.1.0
###
popd
