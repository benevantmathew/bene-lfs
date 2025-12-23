#!/bin/bash
# ======================================================
#  Script Name: build-make-ca.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  LFS: 12.4
#  Purpose: Build make-ca for LFS
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

pushd "$SRC"
###
tar -xvf make-ca-1.16.1.tar.gz
cd make-ca-1.16.1
###
# BUILD
make install &&
install -vdm755 /etc/ssl/local
# maintain
/usr/sbin/make-ca -g
cat > /etc/cron.weekly/update-pki.sh << "EOF" &&
#!/bin/bash
/usr/sbin/make-ca -g
EOF
chmod 754 /etc/cron.weekly/update-pki.sh
###
cd ..
rm -rf make-ca-1.16.1
###
popd
