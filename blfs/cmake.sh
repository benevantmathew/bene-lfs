#!/bin/bash
# ======================================================
#  Script Name: git.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  Purpose: Install git for LFS
# ======================================================

set -euo pipefail

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils/config.sh"
source "$SCRIPT_DIR/utils/require.sh"

# ======================================================

require curl
require libarchive
require libuv
require icu
require libxml2
require nghttp2
require cmake
