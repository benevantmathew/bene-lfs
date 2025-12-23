#!/bin/bash
# ======================================================
#  Script Name: build-perl_pass1.sh
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
tar -xvf perl-5.42.0.tar.xz
cd perl-5.42.0
###

# BUILD
sh Configure -des                                 \
    -D prefix=/usr                                \
    -D vendorprefix=/usr                          \
    -D useshrplib                                \
    -D privlib=/usr/lib/perl5/5.42/core_perl     \
    -D archlib=/usr/lib/perl5/5.42/core_perl     \
    -D sitelib=/usr/lib/perl5/5.42/site_perl     \
    -D sitearch=/usr/lib/perl5/5.42/site_perl    \
    -D vendorlib=/usr/lib/perl5/5.42/vendor_perl \
    -D vendorarch=/usr/lib/perl5/5.42/vendor_perl
make
make install

###
cd ..
rm -rf perl-5.42.0
###
popd
