#!/bin/bash
# ======================================================
#  Script Name: build-sed.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build sed for LFS
# ======================================================
# configure
PHASE=04-system
PKG=sed

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

[ "$(id -u)" -eq 0 ] || {
    echo "ERROR: $PKG must be built as root inside chroot" >&2
    exit 1
}

pushd "$SRC"
###
rm -rf sed-4.9
tar -xvf sed-4.9.tar.xz
cd sed-4.9
###

# BUILD
./configure --prefix=/usr
make
make html

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
fi
# ======================================================

make install
install -d -m755           /usr/share/doc/sed-4.9
install -m644 doc/sed.html /usr/share/doc/sed-4.9

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf sed-4.9
###
popd
