#!/bin/bash
# ======================================================
#  Script Name: lfs_require.sh
#  Author: Benevant Mathew
#  Created: 2025-12-06
#  Purpose: Helper function for LFS
# ======================================================
# Ensure LFS is set (Critical for Chapter 5 context)
if [ -z "$LFS" ]; then
    echo "ERROR: The LFS environment variable is not set." >&2
    return 1 2>/dev/null || exit 1
fi
if [ ! -d "$LFS/tools" ]; then
    echo "ERROR: \$LFS/tools directory not found. Is LFS mounted and setup correct?" >&2
    return 1 2>/dev/null || exit 1
fi

lfs_require() {
    local pkg="$1"
    local temp_bin="$LFS/tools/bin"
    local temp_lib="$LFS/tools/lib"

    # 1. Check if the binary is installed in the temporary LFS tools directory
    # This is the primary check for Chapter 5 tools.
    if [ -x "$temp_bin/$pkg" ]; then
        echo "--> $pkg already installed (detected binary in \$LFS/tools/bin)"
        return 0
    fi

    # 2. Check if a library is installed in the temporary LFS tools directory
    # NOTE: This is a simplistic check for static tools, more complex for shared libs.
    # We check if the expected shared object file exists.
    if [ -f "$temp_lib/lib$pkg.so" ] || [ -f "$temp_lib/lib${pkg}.a" ]; then
        echo "--> $pkg already installed (detected library in \$LFS/tools/lib)"
        return 0
    fi

    # 3. Not installed → build it
    echo "--> Installing dependency: $pkg"

    if ! bash "$SCRIPT_DIR/../builds/build-$pkg.sh"; then
        echo "ERROR: Failed building $pkg" >&2
        return 1 2>/dev/null || exit 1
    fi

}