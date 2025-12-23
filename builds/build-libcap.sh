#!/bin/bash
# ======================================================
#  Script Name: build-libcap.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build libcap for LFS
# ======================================================
# configure
PHASE=04-system
PKG=libcap

# ======================================================
# Logging
# added only where tests exist
LOG_ROOT=/logs
LOG_DIR="$LOG_ROOT/$PHASE"
LOG_FILE="$LOG_DIR/$PKG.check.log"

mkdir -p "$LOG_DIR"

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
rm -rf libcap-2.76
tar -xvf libcap-2.76.tar.xz
cd libcap-2.76
###

# BUILD
sed -i '/install -m.*STA/d' libcap/Makefile
make prefix=/usr lib=lib

# ======================================================
# Tests
echo "Running $PKG test suite..."
if make test >"$LOG_FILE" 2>&1; then
    echo "✅ $PKG tests passed"
else
    echo "⚠️  $PKG tests failed — review $LOG_FILE"
fi

# ======================================================

make prefix=/usr lib=lib install

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf libcap-2.76
###
popd
