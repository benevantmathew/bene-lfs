#!/bin/bash
# ======================================================
#  Script Name: lfs_partioning.sh
#  Author: Benevant Mathew
#  Created: 2025-12-13
#  Purpose: Format any drive to my LFS os dirive.
#  Run as root user
#  Usage: ./lfs_partioning.sh /dev/sdX
#  [need]: parted, dosfstools
#  Description: 3 drives. efi, swap, root
# ======================================================

# ================= USER CONFIG =================
EFI_SIZE_MIB=1024    # 512, 1024, etc
SWAP_SIZE_GIB=32     # 8, 16, 32, etc
# ===============================================
EFI_START_MIB=1
EFI_END_MIB=$((EFI_START_MIB + EFI_SIZE_MIB))

SWAP_START_MIB=$EFI_END_MIB
SWAP_SIZE_MIB=$((SWAP_SIZE_GIB * 1024))
SWAP_END_MIB=$((SWAP_START_MIB + SWAP_SIZE_MIB))

ROOT_START_MIB=$SWAP_END_MIB
# ===============================================

set -euo pipefail

DEVICE="${1:-}"

if [[ -z "$DEVICE" ]]; then
    echo "Usage: $0 <device>"
    echo "Example: $0 /dev/sdb"
    exit 1
fi

# Safety confirmation
echo ">>> WARNING: This will ERASE all data on $DEVICE"
read -rp "Type 'YES' to continue: " CONFIRM
if [[ "$CONFIRM" != "YES" ]]; then
    echo "Aborted."
    exit 1
fi

if [[ ! -b "$DEVICE" ]]; then
    echo "Error: $DEVICE not found."
    exit 1
fi

echo "[*] Unmounting any mounted partitions..."
lsblk -ln -o NAME,MOUNTPOINT "$DEVICE" | awk '$2 != "" {print "/dev/"$1}' | xargs -r umount

echo "[*] Wiping old filesystem signatures..."
wipefs -a "$DEVICE"

echo "[*] Creating new GPT partition table..."
parted -s "$DEVICE" mklabel gpt

echo "[*] Creating EFI System partition (${EFI_SIZE_MIB} MiB)..."
# 1MB offset in standard and needed for easier I/O cycles.
parted -s "$DEVICE" mkpart ESP fat32 "${EFI_START_MIB}MiB" "${EFI_END_MIB}MiB"
# sets the EFI System Partition flag
parted -s "$DEVICE" set 1 esp on

echo "[*] Creating swap partition (${SWAP_SIZE_GIB} GiB)..."
parted -s "$DEVICE" mkpart primary linux-swap \
    "${SWAP_START_MIB}MiB" "${SWAP_END_MIB}MiB"

echo "[*] Creating root partition (rest of disk)..."
parted -s "$DEVICE" mkpart primary ext4 "${ROOT_START_MIB}MiB" 100%

# Ensure kernel sees new partitions
partprobe "$DEVICE"
udevadm settle

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

echo "[*] Detected partitions:"
echo "EFI : $P1"
echo "SWAP: $P2"
echo "ROOT: $P3"
lsblk "$DEVICE"

# Safety confirmation
echo ">>> WARNING: Verify partition layout on $DEVICE before formatting"
read -rp "Type 'YES' to continue: " CONFIRM
if [[ "$CONFIRM" != "YES" ]]; then
    echo "Aborted."
    exit 1
fi

echo "[*] Formatting EFI partition..."
mkfs.fat -F 32 "$P1"

echo "[*] Creating swap partition..."
mkswap "$P2"

echo "[*] Formatting root partition..."
mkfs.ext4 -F "$P3"

echo "✅ Done!"
