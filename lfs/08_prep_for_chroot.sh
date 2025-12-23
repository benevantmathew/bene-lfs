#!/bin/bash
# ======================================================
#  Script Name: 08_prep_for_chroot.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  Purpose:
#  Run as root user
#  Usage: bash ./08_prep_for_chroot.sh
# ======================================================

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/config.sh"

# --- Safety checks ---
[ "$EUID" -eq 0 ] || {
    echo "ERROR: Must be run as root" >&2
    return 1 2>/dev/null || exit 1
}

[ -d "$LFS" ] || {
    echo "ERROR: LFS not mounted at $LFS" >&2
    return 1 2>/dev/null || exit 1
}

# --- Ownership ---
chown --from lfs -R root:root "$LFS"/{usr,var,etc,tools} 2>/dev/null || true
case $(uname -m) in
    x86_64) chown --from lfs -R root:root "$LFS/lib64" 2>/dev/null || true;;
esac

# --- Directory creation ---
mkdir -pv "$LFS"/{dev,proc,sys,run}

# --- Mounting ---
if mountpoint -q "$LFS/dev"; then
    echo "--> $LFS/dev already mounted"
else
    mount -v --bind /dev "$LFS/dev"
fi

if mountpoint -q "$LFS/dev/pts"; then
    echo "--> $LFS/dev/pts already mounted"
else
    mount -vt devpts devpts -o gid=5,mode=0620 "$LFS/dev/pts"
fi

if mountpoint -q "$LFS/proc"; then
    echo "--> $LFS/proc already mounted"
else
    mount -vt proc proc "$LFS/proc"
fi

if mountpoint -q "$LFS/sys"; then
    echo "--> $LFS/sys already mounted"
else
    mount -vt sysfs sysfs "$LFS/sys"
fi

if mountpoint -q "$LFS/run"; then
    echo "--> $LFS/run already mounted"
else
    mount -vt tmpfs tmpfs "$LFS/run"
fi


# --- /dev/shm handling ---
if [ -h "$LFS/dev/shm" ]; then
    install -v -d -m 1777 "$LFS$(realpath /dev/shm)"
else
    if mountpoint -q "$LFS/dev/shm"; then
        echo "--> $LFS/dev/shm already mounted"
    else
        mount -vt tmpfs -o nosuid,nodev tmpfs "$LFS/dev/shm"
    fi

fi

echo "✔ LFS is ready for chroot"