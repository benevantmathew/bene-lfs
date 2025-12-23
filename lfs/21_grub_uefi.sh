#!/bin/bash
# ======================================================
#  Script Name: 21_grub_uefi.sh
#  Author: Benevant Mathew
#  Created: 2025-12-23
#  Purpose:
#  LFS: 12.4
#  Usage: ./21_grub_uefi.sh /dev/sdX
# ======================================================

set -euo pipefail

PHASE=05-config
PKG=grub_uefi

# -------------------------
# Input validation
# -------------------------
if [ -z "${1:-}" ]; then
    echo "Usage: $0 /dev/sdX | /dev/nvme0n1"
    exit 1
fi

DEVICE="$1"

# -------------------------
# Detect partition scheme
# -------------------------
if [[ "$DEVICE" =~ nvme[0-9]+n[0-9]+$ ]]; then
    EFI_PART="${DEVICE}p1"
    ROOT_PART="${DEVICE}p3"
else
    EFI_PART="${DEVICE}1"
    ROOT_PART="${DEVICE}3"
fi

# -------------------------
# User config (non-device)
# -------------------------
BOOTLOADER_ID="LFS-BENEVANT"
KERNEL_VERSION="6.16.1-lfs-12.4"
GRUB_TIMEOUT=5

# -------------------------
# Stamp
# -------------------------
STAMP_ROOT=/stamps
STAMP_DIR="$STAMP_ROOT/$PHASE"
STAMP="$STAMP_DIR/$PKG.done"

[ -f "$STAMP" ] && {
    echo "$PKG already configured — skipping"
    exit 0
}

# -------------------------
# Safety checks
# -------------------------
[ "$(id -u)" -eq 0 ] || {
    echo "ERROR: Must run as root"
    exit 1
}

[ -d /sys/firmware/efi ] || {
    echo "ERROR: System not booted in UEFI mode"
    exit 1
}

for part in "$EFI_PART" "$ROOT_PART"; do
    [ -b "$part" ] || {
        echo "ERROR: Block device $part does not exist"
        exit 1
    }
done

mountpoint -q /boot/efi || {
    echo "ERROR: /boot/efi is not mounted"
    exit 1
}

# -------------------------
# Mount efivarfs
# -------------------------
if ! mountpoint -q /sys/firmware/efi/efivars; then
    mount -v -t efivarfs efivarfs /sys/firmware/efi/efivars
fi

grep -q efivarfs /etc/fstab || cat >> /etc/fstab << EOF
efivarfs /sys/firmware/efi/efivars efivarfs defaults 0 0
EOF

# -------------------------
# Install GRUB
# -------------------------
grub-install \
    --target=x86_64-efi \
    --efi-directory=/boot/efi \
    --bootloader-id="$BOOTLOADER_ID" \
    --recheck

# -------------------------
# Generate grub.cfg
# -------------------------
cat > /boot/grub/grub.cfg << EOF
# Begin /boot/grub/grub.cfg

set default=0
set timeout=${GRUB_TIMEOUT}

insmod part_gpt
insmod ext2

menuentry "GNU/Linux (${KERNEL_VERSION})" {
    linux /boot/vmlinuz-${KERNEL_VERSION} root=${ROOT_PART} ro
}

menuentry "Firmware Setup" {
    fwsetup
}

# End /boot/grub/grub.cfg
EOF

# -------------------------
# Show EFI entries
# -------------------------
efibootmgr

# -------------------------
# Stamp
# -------------------------
mkdir -p "$STAMP_DIR"
touch "$STAMP"

echo "GRUB UEFI installation complete for device: $DEVICE"
