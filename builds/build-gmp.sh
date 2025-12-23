#!/bin/bash
# ======================================================
#  Script Name: build-gmp.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build gmp for LFS
# ======================================================
# configure
PHASE=04-system
PKG=gmp

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
rm -rf gmp-6.3.0
tar -xvf gmp-6.3.0.tar.xz
cd gmp-6.3.0
###

# BUILD
sed -i '/long long t1;/,+1s/()/(...)/' configure
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.3.0
make
make html

# ======================================================
# NOTE: GMP reports cumulative PASS counts; failures may be environment-specific
# Tests
echo "Running $PKG test suite..."

make -k check >"$LOG_FILE" 2>&1 || true

# Extract failures
grep -E "FAIL|ERROR|UNRESOLVED" "$LOG_FILE" >"$SUMMARY_FILE" || true

# GMP-specific: count total passed tests
PASS_COUNT=$(awk '/# PASS:/{total+=$3} END{print total+0}' "$LOG_FILE" 2>/dev/null)

if [ -s "$SUMMARY_FILE" ]; then
    echo "⚠️  $PKG tests had failures — review $SUMMARY_FILE"
    echo "ℹ️  GMP tests passed so far: $PASS_COUNT"
else
    echo "✅ $PKG tests completed with no detected failures"
    echo "ℹ️  GMP total tests passed: $PASS_COUNT"
fi
# ======================================================

make install
make install-html

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf gmp-6.3.0
###
popd
