#!/bin/bash
# ======================================================
#  Script Name: build-sshd.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build sshd for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf openssh-10.0p1.tar.gz
cd openssh-10.0p1
###
# BUILD
install -v -g sys -m700 -d /var/lib/sshd &&

groupadd -g 50 sshd        &&
useradd  -c 'sshd PrivSep' \
         -d /var/lib/sshd  \
         -g sshd           \
         -s /bin/false     \
         -u 50 sshd
./configure --prefix=/usr                            \
            --sysconfdir=/etc/ssh                    \
            --with-privsep-path=/var/lib/sshd        \
            --with-default-path=/usr/bin             \
            --with-superuser-path=/usr/sbin:/usr/bin \
            --with-pid-dir=/run                      &&
make
make install &&
install -v -m755    contrib/ssh-copy-id /usr/bin     &&

install -v -m644    contrib/ssh-copy-id.1 \
                    /usr/share/man/man1              &&
install -v -m755 -d /usr/share/doc/openssh-10.0p1     &&
install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    /usr/share/doc/openssh-10.0p1
# CONFIGURE
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
###
cd ..
rm -rf openssh-10.0p1
###
popd
