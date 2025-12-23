#!/bin/bash
# ======================================================
#  Script Name: 99_finalize_system.sh
#  Author: Benevant Mathew
#  Created: 2025-12-23
#  Purpose: Final system checks before first real boot
#  LFS: 12.4
# ======================================================

set -e

echo
echo "===================================================="
echo " LFS Final System Finalization"
echo "===================================================="
echo

# ------------------------------------------------------
# Must be root
# ------------------------------------------------------
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: This script must be run as root"
    exit 1
fi

# ------------------------------------------------------
# Verify essential account files
# ------------------------------------------------------
echo "[*] Verifying account files..."
for f in /etc/passwd /etc/group /etc/shadow; do
    if [ ! -f "$f" ]; then
        echo "ERROR: Missing critical file: $f"
        exit 1
    fi
done
echo "    OK"

# ------------------------------------------------------
# Enforce root password
# ------------------------------------------------------
echo
echo "[*] Checking root password..."

if ! passwd -S root 2>/dev/null | grep -q ' P '; then
    echo
    echo "Root password is NOT set."
    echo "You must set a root password before first boot."
    echo
    passwd
    echo
    echo "Root password set successfully."
else
    echo "    Root password already set."
fi

# ------------------------------------------------------
# Hostname & hosts
# ------------------------------------------------------
echo
echo "[*] Checking hostname configuration..."

if [ ! -f /etc/hostname ]; then
    echo "WARNING: /etc/hostname is missing"
else
    echo "    Hostname: $(cat /etc/hostname)"
fi

if [ ! -f /etc/hosts ]; then
    echo "WARNING: /etc/hosts is missing"
else
    echo "    /etc/hosts present"
fi

# ------------------------------------------------------
# Timezone
# ------------------------------------------------------
echo
echo "[*] Checking timezone..."

if [ ! -e /etc/localtime ]; then
    echo "WARNING: Timezone not configured (/etc/localtime missing)"
else
    echo "    Timezone configured"
fi

# ------------------------------------------------------
# Locale
# ------------------------------------------------------
echo
echo "[*] Checking locale..."

if ! locale | grep -q '^LANG='; then
    echo "WARNING: Locale not configured (LANG missing)"
else
    locale | grep '^LANG='
fi

# ------------------------------------------------------
# fstab (CRITICAL)
# ------------------------------------------------------
echo
echo "[*] Checking /etc/fstab..."

if [ ! -f /etc/fstab ]; then
    echo "ERROR: /etc/fstab is missing — system will NOT boot"
    exit 1
else
    echo "    /etc/fstab present"
fi

# ------------------------------------------------------
# Bootloader sanity (UEFI only)
# ------------------------------------------------------
echo
echo "[*] Checking boot environment..."

if [ -d /sys/firmware/efi ]; then
    echo "    UEFI system detected"
    if ! command -v efibootmgr >/dev/null 2>&1; then
        echo "WARNING: efibootmgr not found"
    else
        echo "    efibootmgr available"
    fi
else
    echo "    Legacy BIOS system detected"
fi

# ------------------------------------------------------
# Init system check (informational)
# ------------------------------------------------------
echo
echo "[*] Checking init system..."

if [ -x /sbin/init ]; then
    readlink -f /sbin/init
else
    echo "WARNING: /sbin/init not found"
fi

# ------------------------------------------------------
# Completion
# ------------------------------------------------------
echo
echo "===================================================="
echo " Finalization complete"
echo
echo "Review any WARNINGS above."
echo "It is now safe to:"
echo "  1) Exit chroot"
echo "  2) Unmount filesystems"
echo "  3) Reboot into LFS"
echo "===================================================="
echo
