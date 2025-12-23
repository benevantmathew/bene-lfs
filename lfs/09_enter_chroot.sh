#!/bin/bash
# ======================================================
#  Script Name: 09_enter_chroot.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  Purpose:
#  Run as root user
#  Usage: bash ./09_enter_chroot.sh
# ======================================================

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils/lfs_config.sh"

# ENTERING CHROOT

chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    MAKEFLAGS="-j$(nproc)"      \
    TESTSUITEFLAGS="-j$(nproc)" \
    /bin/bash --login
