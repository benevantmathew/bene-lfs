#!/bin/bash
# ======================================================
#  Script Name: build-dhcpcd.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build dhcpcd for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf dhcpcd-10.2.4.tar.xz
cd dhcpcd-10.2.4
###
# BUILD
./configure --prefix=/usr                \
            --sysconfdir=/etc            \
            --libexecdir=/usr/lib/dhcpcd \
            --dbdir=/var/lib/dhcpcd      \
            --runstatedir=/run           \
            --disable-privsep         &&
make
make install
###
cd ..
rm -rf dhcpcd-10.2.4
###
popd
