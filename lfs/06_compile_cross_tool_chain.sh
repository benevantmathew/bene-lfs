#!/bin/bash
# ======================================================
#  Script Name: 06_compile_tools.sh
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

# temporary toolchain
lfs_require binutils_pass1
lfs_require gcc_pass1
lfs_require linux_headers
lfs_require glibc_pass1
lfs_require libstdc
