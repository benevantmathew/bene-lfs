#!/bin/bash
# ======================================================
#  Script Name: build-pciutils.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build pciutils for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf pciutils-3.14.0.tar.gz
cd pciutils-3.14.0
###
# BUILD
sed -r '/INSTALL/{/PCI_IDS|update-pciids /d; s/update-pciids.8//}' \
    -i Makefile
make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes
make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes                 \
     install install-lib        &&

chmod -v 755 /usr/lib/libpci.so
###
cd ..
rm -rf pciutils-3.14.0
###
popd
