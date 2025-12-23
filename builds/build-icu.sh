#!/bin/bash
# ======================================================
#  Script Name: build-icu.sh
#  Author: Benevant Mathew
#  Created: 2025-12-23
#  LFS: 12.4
#  Purpose: Build icu for LFS
# ======================================================
set -euo pipefail

# configure
PHASE=blfs
PKG=icu

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
rm -rf icu
tar -xvf icu4c-77_1-src.tgz
cd icu
###

# BUILD
case $(uname -m) in
    i?86) sed -e "s/U_PLATFORM_IS_LINUX_BASED/__X86_64__ \&\& &/" \
                -i source/test/intltest/ustrtest.cpp ;;
esac

cd source                 &&
./configure --prefix=/usr &&
make

make install

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf icu
###
popd
