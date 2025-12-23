#!/bin/bash
# ======================================================
#  Script Name: rebuild_kernel.sh
#  Author: Benevant Mathew
#  Created: 2025-12-08
#  Purpose: Rebuild Kernel for LFS
# ======================================================

# --- Configuration ---
KERNEL_SOURCE="/sources/linux-6.16.1"
KERNEL_VERSION="6.16.1"

# --- Pre-flight Checks ---
if [ ! -d "$KERNEL_SOURCE" ]; then
    echo "ERROR: Kernel source directory not found at $KERNEL_SOURCE."
    exit 1
fi

if [ ! -f "$KERNEL_SOURCE/.config" ]; then
    echo "ERROR: .config file not found in $KERNEL_SOURCE. Run 'make menuconfig' first."
    exit 1
fi

echo "Starting full kernel build and module installation for $KERNEL_VERSION..."
echo "--------------------------------------------------------"

# --- Core Build Process ---

cd "$KERNEL_SOURCE" || exit 1

# 1. Clean up intermediate build files (keeps .config)
echo "1/5: Cleaning up old build files..."
make clean

# 2. Build the entire kernel (core image and modules)
# This step resolves symbol dependencies required for iwlwifi.ko
echo "2/5: Starting full kernel compilation (This will take time)..."
make

# Check for compilation errors
if [ $? -ne 0 ]; then
    echo "FATAL: Kernel compilation failed. Check the errors above."
    exit 1
fi

# 3. Install the core kernel image and System.map
echo "3/5: Installing kernel image (vmlinuz) and System.map..."
make install

# 4. Install modules to /lib/modules/
echo "4/5: Installing modules to /lib/modules/$KERNEL_VERSION/ ..."
make modules_install

# 5. Update module dependency database
echo "5/5: Updating module dependency database (depmod -a)..."
depmod -a

echo "--------------------------------------------------------"
echo "✅ Kernel rebuild and module installation complete."
echo "NEXT STEP: Reboot the system to load the new kernel."
echo "--------------------------------------------------------"