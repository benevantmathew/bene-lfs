#!/bin/bash
# ======================================================
#  Script Name: build-p11-kit.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build p11-kit for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf p11-kit-0.25.5.tar.xz
cd p11-kit-0.25.5
###
# CONFIGURE
sed '20,$ d' -i trust/trust-extract-compat &&

cat >> trust/trust-extract-compat << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Update trust stores
/usr/sbin/make-ca -r
EOF
# BUILD
mkdir p11-build &&
cd    p11-build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D trust_paths=/etc/pki/anchors &&
ninja
ninja install &&
ln -sfv /usr/libexec/p11-kit/trust-extract-compat \
        /usr/bin/update-ca-certificates
ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so
###
cd ..
rm -rf p11-kit-0.25.5
###
popd
