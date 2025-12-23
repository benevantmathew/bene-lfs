#!/bin/bash
# ======================================================
#  Script Name: wget.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  Purpose: Install wget for LFS
# ======================================================

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils/config.sh"
source "$SCRIPT_DIR/utils/require.sh"

# ======================================================

require libtasn1
require p11-kit
require make-ca
require libunistring
require libidn2
require libpsl
require wget

