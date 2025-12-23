#!/bin/bash
# ======================================================
#  Script Name: build-make.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build make for LFS
# ======================================================
# configure
PHASE=04-system
PKG=make

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
rm -rf make-4.4.1
tar -xvf make-4.4.1.tar.gz
cd make-4.4.1
###

# BUILD
./configure --prefix=/usr
make

# ======================================================
# Tests
echo "Running $PKG test suite..."
if id tester &>/dev/null; then
    chown -R tester .
    # Run tests as tester, log output
    su tester -c "PATH=$PATH make -k check" >"$LOG_FILE" 2>&1 || true

    # Extract FAIL, ERROR, UNRESOLVED lines
    grep -E "FAIL|ERROR|UNRESOLVED" "$LOG_FILE" >"$SUMMARY_FILE" || true

    if [ -s "$SUMMARY_FILE" ]; then
        echo "⚠️  $PKG tests had failures — review $SUMMARY_FILE"
    else
        echo "✅ $PKG tests completed with no detected failures"
    fi
else
    echo "Tester user not found — skipping $PKG tests"
    echo "⚠️  Skipping $PKG tests because tester user does not exist" >>"$LOG_FILE"
fi
# ======================================================

make install

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf make-4.4.1
###
popd
