#!/bin/bash
# ======================================================
#  Script Name: build-gettext_pass1.sh
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
tar -xvf gettext-0.26.tar.xz
cd gettext-0.26
###

# BUILD
./configure --disable-shared
make
# install files
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin

###
cd ..
rm -rf gettext-0.26
###
popd
