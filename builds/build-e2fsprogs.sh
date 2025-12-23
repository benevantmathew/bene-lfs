#!/bin/bash
# ======================================================
#  Script Name: build-e2fsprogs.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build e2fsprogs for LFS
# ======================================================
# configure
PHASE=04-system
PKG=e2fsprogs

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
rm -rf e2fsprogs-1.47.3
tar -xvf e2fsprogs-1.47.3.tar.gz
cd e2fsprogs-1.47.3
###

# BUILD
mkdir -v build
cd       build
../configure --prefix=/usr       \
            --sysconfdir=/etc   \
            --enable-elf-shlibs \
            --disable-libblkid  \
            --disable-libuuid   \
            --disable-uuidd     \
            --disable-fsck
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
rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ../..
rm -rf e2fsprogs-1.47.3
###
popd
