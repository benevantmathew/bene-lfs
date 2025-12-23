#!/bin/bash
# ======================================================
#  Script Name: build-git.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build git for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf git-2.50.1.tar.xz
cd git-2.50.1
###
# build
./configure --prefix=/usr \
            --with-gitconfig=/etc/gitconfig \
            --with-python=python3 &&
make
make perllibdir=/usr/lib/perl5/5.42/site_perl install
###
cd ..
rm -rf git-2.50.1
###
popd
