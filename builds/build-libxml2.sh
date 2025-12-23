#!/bin/bash
# ======================================================
#  Script Name: build-libxml2.sh
#  Author: Benevant Mathew
#  Created: 2025-12-23
#  LFS: 12.4
#  Purpose: Build libxml2 for LFS
# ======================================================
set -euo pipefail

# configure
PHASE=blfs
PKG=libxml2

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
rm -rf libxml2-2.14.5
tar -xvf libxml2-2.14.5.tar.xz
cd libxml2-2.14.5
###

# BUILD
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --with-history    \
            --with-icu        \
            PYTHON=/usr/bin/python3 \
            --docdir=/usr/share/doc/libxml2-2.14.5 &&
make

# Tests
tar xf ../xmlts20130923.tar.gz

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

#  prevent some packages from unnecessarily linking to ICU 
rm -vf /usr/lib/libxml2.la &&
sed '/libs=/s/xml2.*/xml2"/' -i /usr/bin/xml2-config

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf libxml2-2.14.5
###
popd
