#!/bin/bash
# ======================================================
#  Script Name: 17_install_lfs_bootscripts.sh
#  Author: Benevant Mathew
#  Created: 2025-12-22
#  Purpose:
#  source "scripts/lfs/utils/config.sh" first
# ======================================================

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils/config.sh"
source "$SCRIPT_DIR/utils/require.sh"

# ======================================================

require lfs_bootscripts
