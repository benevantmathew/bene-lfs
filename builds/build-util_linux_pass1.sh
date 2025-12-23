#!/bin/bash
# ======================================================
#  Script Name: build-util_linux_pass1.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build Binutils for Tool Chain
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf util-linux-2.41.1.tar.xz
cd util-linux-2.41.1
###

# BUILD
mkdir -pv /var/lib/hwclock
./configure --libdir=/usr/lib     \
    --runstatedir=/run    \
    --disable-chfn-chsh   \
    --disable-login       \
    --disable-nologin     \
    --disable-su          \
    --disable-setpriv     \
    --disable-runuser     \
    --disable-pylibmount  \
    --disable-static      \
    --disable-liblastlog2 \
    --without-python      \
    ADJTIME_PATH=/var/lib/hwclock/adjtime \
    --docdir=/usr/share/doc/util-linux-2.41.1
make
make install

###
cd ..
rm -rf util-linux-2.41.1
###
popd
