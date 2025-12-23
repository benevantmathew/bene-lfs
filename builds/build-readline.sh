#!/bin/bash
# ======================================================
#  Script Name: build-readline.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build readline for LFS
# ======================================================
set -e
# configure
PHASE=04-system
PKG=readline

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
rm -rf readline-8.3
tar -xvf readline-8.3.tar.gz
cd readline-8.3
###

# BUILD
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf
./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.3
make SHLIB_LIBS="-lncursesw"
make install
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.3

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf readline-8.3
###
popd
