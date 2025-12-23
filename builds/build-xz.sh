#!/bin/bash
# ======================================================
#  Script Name: build-xz.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build xz for LFS
# ======================================================
# configure
PHASE=04-system
PKG=xz

# ======================================================
# Logging
# added only where tests exist
LOG_ROOT=/logs
LOG_DIR="$LOG_ROOT/$PHASE"
LOG_FILE="$LOG_DIR/$PKG.check.log"
SUMMARY_FILE="$LOG_DIR/$PKG.check.summary"

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

pushd "$SRC"
###
rm -rf xz-5.8.1
tar -xvf xz-5.8.1.tar.xz
cd xz-5.8.1
###

# BUILD
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.8.1make
make

# ======================================================
# Tests
echo "Running $PKG test suite..."
make -k check >"$LOG_FILE" 2>&1 || true

grep -E "FAIL|ERROR|UNRESOLVED" "$LOG_FILE" >"$SUMMARY_FILE" || true
if [ -s "$SUMMARY_FILE" ]; then
    echo "⚠️  $PKG tests had failures — review $SUMMARY_FILE"
else
    echo "✅ $PKG tests completed with no detected failures"
fi
# ======================================================

make install

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf xz-5.8.1
###
popd
