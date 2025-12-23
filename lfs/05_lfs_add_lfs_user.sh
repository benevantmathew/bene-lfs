#!/bin/bash
# ======================================================
#  Script Name: 05_lfs_add_lfs_user.sh
#  Author: Benevant Mathew
#  Created: 2025-12-14
#  Purpose: Create lfs user
#  Run as root user
#  Usage: source ./05_lfs_add_lfs_user.sh
# ======================================================
export LFS=/mnt/lfs

# Adding LFS user
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

## change password
passwd lfs

## Grant lfs full access to all the directories under $LFS by making lfs the owner
chown -v lfs $LFS/{usr{,/*},var,etc,tools}
case $(uname -m) in
    x86_64) chown -v lfs $LFS/lib64 ;;
esac

# SET UP ENVIRONMENT FILES FOR THE 'lfs' USER
# Note: Use 'tee' with 'sudo' or output redirection with 'chown' to write to the lfs user's home directory.

# Create .bash_profile
cat > /home/lfs/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
chown lfs:lfs /home/lfs/.bash_profile

# Create .bashrc
cat > /home/lfs/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
export MAKEFLAGS=-j$(nproc)
EOF
chown lfs:lfs /home/lfs/.bashrc

echo "---"
echo "✅ Script 04 completed successfully."
echo "NEXT STEP: Switch to the 'lfs' user manually before continuing with the build."
echo "Please run: su - lfs"