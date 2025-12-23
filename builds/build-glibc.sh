#!/bin/bash
# ======================================================
#  Script Name: build-glibc.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build glibc for LFS
#  in chapter 8: glibc is reinstalled on top of itself.
#  so file check will fail there.
# ======================================================
# configure
PHASE=04-system
PKG=glibc

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
rm -rf glibc-2.42
tar -xvf glibc-2.42.tar.xz
cd glibc-2.42
###

# BUILD

[ -f ../glibc-2.42-fhs-1.patch ] || {
    echo "ERROR: $PKG FHS patch missing" >&2
    exit 1
}

patch -Np1 -i ../glibc-2.42-fhs-1.patch
sed -e '/unistd.h/i #include <string.h>' \
    -e '/libc_rwlock_init/c\
    __libc_rwlock_define_initialized (, reset_lock);\
    memcpy (&lock, &reset_lock, sizeof (lock));' \
    -i stdlib/abort.c

mkdir -v build
cd build

echo "rootsbindir=/usr/sbin" > configparms

../configure --prefix=/usr                   \
            --disable-werror                \
            --disable-nscd                  \
            libc_cv_slibdir=/usr/lib        \
            --enable-stack-protector=strong \
            --enable-kernel=5.4
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

touch /etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
make install


sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd
make localedata/install-locales

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

tar -xf ../../tzdata2025b.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
    asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO tz

ln -sfv /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF

cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
mkdir -pv /etc/ld.so.conf.d

# create "/etc/ld.so.cache" by below line
ldconfig

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ../..
rm -rf glibc-2.42
###
popd
