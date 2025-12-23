#!/bin/bash
# ======================================================
#  Script Name: build-perl.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build perl for LFS
# ======================================================
# configure
PHASE=04-system
PKG=perl

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
rm -rf perl-5.42.0
tar -xvf perl-5.42.0.tar.xz
cd perl-5.42.0
###

# BUILD
export BUILD_ZLIB=False
export BUILD_BZIP2=0
sh Configure -des                                          \
            -D prefix=/usr                                \
            -D vendorprefix=/usr                          \
            -D privlib=/usr/lib/perl5/5.42/core_perl      \
            -D archlib=/usr/lib/perl5/5.42/core_perl      \
            -D sitelib=/usr/lib/perl5/5.42/site_perl      \
            -D sitearch=/usr/lib/perl5/5.42/site_perl     \
            -D vendorlib=/usr/lib/perl5/5.42/vendor_perl  \
            -D vendorarch=/usr/lib/perl5/5.42/vendor_perl \
            -D man1dir=/usr/share/man/man1                \
            -D man3dir=/usr/share/man/man3                \
            -D pager="/usr/bin/less -isR"                 \
            -D useshrplib                                 \
            -D usethreads
make

# ======================================================
# Tests
echo "Running $PKG test suite..."

export TEST_JOBS=$(nproc)

make test_harness >"$LOG_FILE" 2>&1 || true

# Extract failures (Perl does not have a single standard FAIL format,
# but these patterns catch real issues)
grep -E "FAILED|FAIL|ERROR|panic" "$LOG_FILE" >"$SUMMARY_FILE" || true

if [ -s "$SUMMARY_FILE" ]; then
    echo "⚠️  $PKG tests had failures — review $SUMMARY_FILE"
else
    echo "✅ $PKG tests completed with no detected failures"
fi
# ======================================================

make install
unset BUILD_ZLIB BUILD_BZIP2 TEST_JOBS

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf perl-5.42.0
###
popd
