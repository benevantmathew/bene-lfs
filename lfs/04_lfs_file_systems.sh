#!/bin/bash
# ======================================================
#  Script Name: 04_lfs_file_systems.sh
#  Author: Benevant Mathew
#  Created: 2025-12-14
#  Purpose: Create LFS File system
#  Run as root user
#  Usage: bash ./04_lfs_file_systems.sh
# ======================================================
export LFS=/mnt/lfs

# now change the ownership of the source folder to root/
if [ -d "$LFS/sources" ]; then
    chown -R root:root "$LFS/sources"
fi

# create LFS file system
mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

case $(uname -m) in
    x86_64) mkdir -pv $LFS/lib64 ;;
esac

mkdir -pv $LFS/tools

# create symlinks there
for i in bin lib sbin; do
    ln -sv usr/$i $LFS/$i
done
