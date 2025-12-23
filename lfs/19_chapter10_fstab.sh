#!/bin/bash
# ======================================================
#  Script Name: 19_chapter9_fstab.sh
#  Author: Benevant Mathew
#  Purpose: Generate /etc/fstab for LFS
#  Usage: ./19_chapter9_fstab.sh /dev/sdX
#  files changed:
# - /etc/fstab
# ======================================================

set -euo pipefail

# ------------------------------------------------------
# Input validation
# ------------------------------------------------------
if [ -z "${1:-}" ]; then
    echo "Error: Please provide the base device (e.g., /dev/sda or /dev/nvme0n1)"
    echo "Usage: $0 /dev/sdX"
    exit 1
fi

DEVICE="$1"

# ------------------------------------------------------
# Detect partition naming scheme
# ------------------------------------------------------
if [[ "$DEVICE" =~ nvme[0-9]+n[0-9]+$ ]]; then
    P1="${DEVICE}p1"   # EFI
    P2="${DEVICE}p2"   # swap
    P3="${DEVICE}p3"   # root
else
    P1="${DEVICE}1"
    P2="${DEVICE}2"
    P3="${DEVICE}3"
fi

# ------------------------------------------------------
# Sanity checks
# ------------------------------------------------------
for part in "$P1" "$P2" "$P3"; do
    if [ ! -b "$part" ]; then
        echo "Error: Block device $part does not exist"
        exit 1
    fi
done

# ------------------------------------------------------
# Write /etc/fstab
# ------------------------------------------------------
cat > /etc/fstab << EOF
# Begin /etc/fstab

# file system  mount-point    type     options             dump  fsck
#                                                                order

${P3} /              ext4     defaults            1     1
${P1} /boot/efi      vfat     defaults            0     2
${P2} swap           swap     pri=1               0     0

proc           /proc          proc     nosuid,noexec,nodev 0     0
sysfs          /sys           sysfs    nosuid,noexec,nodev 0     0
devpts         /dev/pts       devpts   gid=5,mode=620      0     0
tmpfs          /run           tmpfs    defaults            0     0
devtmpfs       /dev           devtmpfs mode=0755,nosuid    0     0
tmpfs          /dev/shm       tmpfs    nosuid,nodev        0     0
cgroup2        /sys/fs/cgroup cgroup2  nosuid,noexec,nodev 0     0

# End /etc/fstab
EOF

echo "/etc/fstab generated successfully for device: $DEVICE"
