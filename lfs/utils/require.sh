#!/bin/bash
# ======================================================
#  Script Name: require.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  Purpose: Helper function for LFS
#  SCRIPT_DIR comes from the entry script
# ======================================================
# parameter gaurd
: "${SCRIPT_DIR:?ERROR: SCRIPT_DIR is not set. Source the entry script first.}"

require() {
    local pkg="$1"
    local build_script="$SCRIPT_DIR/../builds/build-$pkg.sh"

    # Build script existence
    if [ ! -f "$build_script" ]; then
        echo "ERROR: build script not found: $build_script" >&2
        return 1
    fi

    # Not installed → build it
    echo "--> Installing dependency: $pkg"
    bash "$build_script"
}
