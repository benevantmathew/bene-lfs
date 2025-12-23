#!/bin/bash
# ======================================================
#  Script Name: build-bzip2.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build bzip2 for LFS
# ======================================================
# configure
PHASE=04-system
PKG=bzip2

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

pushd "$SRC"
###
rm -rf bzip2-1.0.8
tar -xvf bzip2-1.0.8.tar.gz
cd bzip2-1.0.8
###

# BUILD
patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
make -f Makefile-libbz2_so
make clean
make
make PREFIX=/usr install
cp -av libbz2.so.* /usr/lib
ln -sv libbz2.so.1.0.8 /usr/lib/libbz2.so
cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
    ln -sfv bzip2 $i
done
rm -fv /usr/lib/libbz2.a

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf bzip2-1.0.8
###
popd
