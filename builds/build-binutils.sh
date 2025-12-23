#!/bin/bash
# ======================================================
#  Script Name: build-binutils.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build binutils for LFS
# ======================================================
# configure
PHASE=04-system
PKG=binutils

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
rm -rf binutils-2.45
tar -xvf binutils-2.45.tar.xz
cd binutils-2.45
###

# BUILD
mkdir -v build
cd build
../configure --prefix=/usr       \
            --sysconfdir=/etc   \
            --enable-ld=default \
            --enable-plugins    \
            --enable-shared     \
            --disable-werror    \
            --enable-64-bit-bfd \
            --enable-new-dtags  \
            --with-system-zlib  \
            --enable-default-hash-style=gnu
make tooldir=/usr

# ======================================================
# Tests
echo "Running $PKG test suite..."
make -k check >"$LOG_FILE" 2>&1 || true

find .. -name '*.log' -exec grep '^FAIL:' {} + \
    >"$SUMMARY_FILE" || true

if [ -s "$SUMMARY_FILE" ]; then
    echo "⚠️  $PKG tests had failures — review $SUMMARY_FILE"
else
    echo "✅ $PKG tests completed with no detected failures"
fi
# ======================================================

make tooldir=/usr install
rm -rfv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a \
        /usr/share/doc/gprofng/

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ../..
rm -rf binutils-2.45
###
popd
