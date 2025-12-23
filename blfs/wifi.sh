#!/bin/bash
# ======================================================
#  Script Name: wifi.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  Purpose: make wifi works for LFS
# ======================================================

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils/config.sh"
source "$SCRIPT_DIR/utils/require.sh"

# ======================================================

require dhcpcd
require libnl
require wpa_supplicant
require iw
