#!/bin/bash
# ======================================================
#  Script Name: build-gcc.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build gcc for LFS
# ======================================================
# configure
PHASE=04-system
PKG=gcc

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
rm -rf gcc-15.2.0
tar -xvf gcc-15.2.0.tar.xz
cd gcc-15.2.0
###

# BUILD
case $(uname -m) in
    x86_64)
        sed -e '/m64=/s/lib64/lib/' \
            -i.orig gcc/config/i386/t-linux64
    ;;
esac
mkdir -v build
cd       build
../configure --prefix=/usr            \
            LD=ld                    \
            --enable-languages=c,c++ \
            --enable-default-pie     \
            --enable-default-ssp     \
            --enable-host-pie        \
            --disable-multilib       \
            --disable-bootstrap      \
            --disable-fixincludes    \
            --with-system-zlib
make
ulimit -s -H unlimited
sed -e '/cpython/d' -i ../gcc/testsuite/gcc.dg/plugin/plugin.exp

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

    # Optional: print test summary
    ../contrib/test_summary >>"$LOG_FILE" 2>&1
else
    echo "Tester user not found — skipping $PKG tests"
    echo "⚠️  Skipping $PKG tests because tester user does not exist" >>"$LOG_FILE"
fi
# ======================================================

make install
chown -v -R root:root \
    /usr/lib/gcc/$(gcc -dumpmachine)/15.2.0/include{,-fixed}
ln -sfvr /usr/bin/cpp /usr/lib
ln -sfv gcc.1 /usr/share/man/man1/cc.1
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/15.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/
echo 'int main(){}' | cc -x c - -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log
grep -B4 '^ /usr/include' dummy.log
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
grep "/lib.*/libc.so.6 " dummy.log
grep found dummy.log
rm -v a.out dummy.log
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ../..
rm -rf gcc-15.2.0
###
popd
