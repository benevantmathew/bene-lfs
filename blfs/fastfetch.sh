#!/bin/bash
# ======================================================
#  Script Name: fastfetch.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  Purpose: Install fastfetch for LFS
# ======================================================

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils/config.sh"
source "$SCRIPT_DIR/utils/require.sh"

# ======================================================

require fastfetch
