#!/bin/bash
# ======================================================
#  Script Name: require.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  Purpose: Helper function for LFS
# ======================================================


require() {
    local pkg="$1"
    local build_script="$SCRIPT_DIR/../builds/build-$pkg.sh"

    # Ensure build script exists
    if [[ ! -f "$build_script" ]]; then
        echo "Error: build script not found:"
        echo "  $build_script"
        exit 1
    fi

    # Check if it's a binary-based package (wget, git, curl, ssh, etc.)
    if command -v "$pkg" >/dev/null 2>&1; then
        echo "--> $pkg already installed (detected binary)"
        return
    fi

    # Check if it's a library-based package (libidn2, libpsl, etc.)
    if ldconfig -p | grep -q "lib${pkg}\.so"; then
        echo "--> $pkg already installed (detected library)"
        return
    fi

    # Not installed → build it
    echo "--> Installing dependency: $pkg"
    bash "$build_script"
}
