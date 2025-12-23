#!/bin/bash
# ======================================================
#  Script Name: build-bash.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build bash for LFS
# ======================================================
# configure
PHASE=04-system
PKG=bash

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
    echo "ERROR: $PKG must run as root in chroot"
    exit 1
}

pushd "$SRC"
###
rm -rf bash-5.3
tar -xvf bash-5.3.tar.gz
cd bash-5.3
###

# BUILD
./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline \
            --docdir=/usr/share/doc/bash-5.3
make

# ======================================================
# Tests (optional, LFS-recommended)
echo "Running $PKG test suite..."

if id tester &>/dev/null && command -v expect &>/dev/null; then
    chown -R tester .

    # Run tests as tester via expect, capture logs
    LC_ALL=C.UTF-8 su -s /usr/bin/expect tester << EOF >"$LOG_FILE" 2>&1 || true
set timeout -1
spawn make tests
expect eof
lassign [wait] _ _ _ value
exit \$value
EOF

    # Extract failures
    grep -E "FAIL|ERROR|UNRESOLVED" "$LOG_FILE" >"$SUMMARY_FILE" || true

    if [ -s "$SUMMARY_FILE" ]; then
        echo "⚠️  $PKG tests had failures — review $SUMMARY_FILE"
    else
        echo "✅ $PKG tests completed with no detected failures"
    fi
else
    echo "Skipping $PKG tests (tester or expect not available)"
fi
# ======================================================

make install

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf bash-5.3
# exec /usr/bin/bash --login
# switch bash at the start of chapter 9
###
popd
