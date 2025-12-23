#!/bin/bash
# ======================================================
#  Script Name: 16_chapter8_cleaning.sh
#  Author: Benevant Mathew
#  Created: 2025-12-22
#  Purpose: clean system
# ======================================================
# configure
PHASE=04-system
PKG=cleaning

# ======================================================
# stamp block
STAMP_ROOT=/stamps
STAMP_DIR="$STAMP_ROOT/$PHASE"
STAMP="$STAMP_DIR/$PKG.done"


[ -f "$STAMP" ] && {
    echo "$PKG already completed — skipping"
    exit 0
}
# ======================================================
# main code

# rm -rf /tmp/*
find /tmp -mindepth 1 -delete

find /usr/lib /usr/libexec -name \*.la -delete

find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf

if id tester &>/dev/null; then
    userdel -r tester
fi

# ======================================================
# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"
