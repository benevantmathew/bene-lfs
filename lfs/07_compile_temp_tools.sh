#!/bin/bash
# ======================================================
#  Script Name: 07_compile_tools.sh
#  Author: Benevant Mathew
#  Created: 2025-12-14
#  Purpose:
#  source "scripts/lfs/utils/config.sh" first
# ======================================================

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils/lfs_config.sh"
source "$SCRIPT_DIR/utils/lfs_require.sh"

# ======================================================

lfs_require m4_pass1
lfs_require ncurses_pass1
lfs_require bash_pass1
lfs_require coreutils_pass1
lfs_require diffutils_pass1
lfs_require file_pass1
lfs_require findutils_pass1
lfs_require gawk_pass1
lfs_require grep_pass1
lfs_require gzip_pass1
lfs_require make_pass1
lfs_require patch_pass1
lfs_require sed_pass1
lfs_require tar_pass1
lfs_require xz_pass1
lfs_require binutils_pass2
lfs_require gcc_pass2
