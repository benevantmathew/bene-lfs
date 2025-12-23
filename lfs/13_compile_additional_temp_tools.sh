#!/bin/bash
# ======================================================
#  Script Name: 09_compile_tools.sh
#  Author: Benevant Mathew
#  Created: 2025-12-14
#  Purpose:
#  source "scripts/lfs/utils/config.sh" first
#  run inside chrootn (LFS)
# ======================================================

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils/config.sh"
source "$SCRIPT_DIR/utils/require.sh"

# ======================================================

require gettext_pass1
require bison_pass1
require perl_pass1
require python_pass1
require texinfo_pass1
require util_linux_pass1
