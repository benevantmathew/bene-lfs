#!/bin/bash
# ======================================================
#  Script Name: build-coreutils.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build coreutils for LFS
# ======================================================
# configure
PHASE=04-system
PKG=coreutils

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
rm -rf coreutils-9.7
tar -xvf coreutils-9.7.tar.xz
cd coreutils-9.7
###

# BUILD
patch -Np1 -i ../coreutils-9.7-upstream_fix-1.patch
patch -Np1 -i ../coreutils-9.7-i18n-1.patch
autoreconf -fv
automake -af
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime
make

# ======================================================
# Tests
echo "Running $PKG test suite..."
if id tester &>/dev/null; then
    # Root tests
    make NON_ROOT_USERNAME=tester check-root >"$LOG_FILE" 2>&1 || true

    # Non-root expensive tests
    getent group dummy >/dev/null || groupadd -g 102 dummy -U tester
    chown -R tester .
    su tester -c "PATH=$PATH make -k RUN_EXPENSIVE_TESTS=yes check" >>"$LOG_FILE" 2>&1 || true
    groupdel dummy

    # Extract failures
    grep -E "FAIL|ERROR|UNRESOLVED|not ok" "$LOG_FILE" >"$SUMMARY_FILE" || true
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
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf coreutils-9.7
###
popd
