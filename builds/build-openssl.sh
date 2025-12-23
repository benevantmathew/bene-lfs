#!/bin/bash
# ======================================================
#  Script Name: build-openssl.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build openssl for LFS
# ======================================================
# configure
PHASE=04-system
PKG=openssl

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
rm -rf openssl-3.5.2
tar -xvf openssl-3.5.2.tar.gz
cd openssl-3.5.2
###

# BUILD
./config --prefix=/usr         \
        --openssldir=/etc/ssl \
        --libdir=lib          \
        shared                \
        zlib-dynamic
make

# ======================================================
# Tests
echo "Running $PKG test suite..."

HARNESS_JOBS=$(nproc) make test >"$LOG_FILE" 2>&1 || true

# Extract failures
grep -E "FAILED|Fail|ERROR|panic|not ok" "$LOG_FILE" >"$SUMMARY_FILE" || true

if [ -s "$SUMMARY_FILE" ]; then
    echo "⚠️  $PKG tests had failures — review $SUMMARY_FILE"
else
    echo "✅ $PKG tests completed with no detected failures"
fi
# ======================================================

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-3.5.2
cp -vfr doc/* /usr/share/doc/openssl-3.5.2

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf openssl-3.5.2
###
popd
