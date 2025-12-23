#!/bin/bash
# ======================================================
#  Script Name: build-expect.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build expect for LFS
# ======================================================
# configure
PHASE=04-system
PKG=expect

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
    echo "ERROR: Tcl must be built as root inside chroot" >&2
    exit 1
}

pushd "$SRC"
###
rm -rf expect5.45.4
tar -xvf expect5.45.4.tar.gz
cd expect5.45.4
###

# BUILD
python3 -c 'from pty import spawn; spawn(["echo", "ok"])'
patch -Np1 -i ../expect-5.45.4-gcc15-1.patch
./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --disable-rpath         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include
make

# ======================================================
# Tests
echo "Running $PKG test suite..."
if make test >"$LOG_FILE" 2>&1; then
    echo "✅ $PKG tests passed"
else
    echo "⚠️  $PKG tests failed — review $LOG_FILE"
fi

# ======================================================

make install
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf expect5.45.4
###
popd
