#!/bin/bash
# ======================================================
#  Script Name: 02_lfs_mounting.sh
#  Author: Benevant Mathew
#  Created: 2025-12-14
#  Purpose: Mount LFS drives to HOST
#  Run as root user
#  Usage: source ./02_lfs_mounting.sh /dev/sdX
# ======================================================

if [ -z "$1" ]; then
    echo "Error: Please provide the device name (e.g., /dev/sda)."
    echo "Usage: $0 /dev/sdX"
    return 1 2>/dev/null || exit 1
fi

DEVICE="$1"

export LFS=/mnt/lfs
umask 022

# Detect partition suffix style
if [[ "$DEVICE" =~ nvme[0-9]+n[0-9]+$ ]]; then
    P1="${DEVICE}p1"
    P2="${DEVICE}p2"
    P3="${DEVICE}p3"
else
    P1="${DEVICE}1"
    P2="${DEVICE}2"
    P3="${DEVICE}3"
fi

# mounting
mount --mkdir "$P3" $LFS
mount --mkdir "$P1" $LFS/boot/efi
swapon "$P2"

# change LFS permission
chown root:root $LFS
chmod 755 $LFS

# for sources
mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources

# copy needed sources
# i have detailed notes in this repo on how to download the sources for 12.4 LFS.