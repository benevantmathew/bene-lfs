#!/bin/bash
# ======================================================
#  Script Name: 20_build_kernel.sh
#  Author: Benevant Mathew
#  Created: 2025-12-23
#  Purpose:
#  LFS: 12.4
# ======================================================

set -e

PHASE=05-config
PKG=linux_kernel
KERNEL_VERSION=6.16.1

# KERNEL_CONFIG_MODE is REQUIRED via CLI
KERNEL_CONFIG_FILE=/usr/src/linux-configs/x86_64-lfs-12.4.config

# ======================================================
# custom block
# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils/config.sh"

# ======================================================
[ "$(id -u)" -eq 0 ] || {
    echo "ERROR: Must be root inside chroot"
    exit 1
}
# ======================================================
# input helper
usage() {
    cat << EOF
Usage:
    $0 <interactive|n-interactive|defconfig|reuse> [-c CONFIG_FILE]

Examples:
    $0 interactive
    $0 defconfig
    $0 reuse -c /scripts/kernel/configs/x86_64-lfs-12.4.config

Notes:
    - interactive    : opens menuconfig
    - n-interactive  : opens nconfig (recommended)
    - defconfig      : non-interactive default kernel
    - reuse          : reuse previously saved .config

EOF
    exit 1
}

# -------------------------
# Parse arguments
# -------------------------
[ $# -eq 0 ] && usage

while getopts ":c:" opt; do
    case "$opt" in
        c) KERNEL_CONFIG_FILE="$OPTARG" ;;
        *) usage ;;
    esac
done

shift $((OPTIND - 1))

KERNEL_CONFIG_MODE="$1"
[ -z "$KERNEL_CONFIG_MODE" ] && usage


# ======================================================

pushd "$SRC"

if [ -d "linux-$KERNEL_VERSION" ]; then
    read -r -p "Source exists. Reuse it? [Y/n]: " ans
    [[ "$ans" =~ ^[Nn]$ ]] && {
        rm -rf "linux-$KERNEL_VERSION"
        tar -xvf "linux-$KERNEL_VERSION.tar.xz"
    }
else
    tar -xvf "linux-$KERNEL_VERSION.tar.xz"
fi


cd "linux-$KERNEL_VERSION"

# ------------------------------------------------------
# Clean tree
# ------------------------------------------------------
make mrproper

# ------------------------------------------------------
# Kernel config handling
# ------------------------------------------------------
case "$KERNEL_CONFIG_MODE" in
    reuse)
        if [ ! -f "$KERNEL_CONFIG_FILE" ]; then
            echo "ERROR: Kernel config file not found: $KERNEL_CONFIG_FILE"
            exit 1
        fi
        echo "Using existing kernel config"
        cp "$KERNEL_CONFIG_FILE" .config
        make olddefconfig
        ;;
    defconfig)
        echo "Using defconfig (non-interactive)"
        make defconfig
        ;;
    interactive)
        echo "Launching menuconfig"

        if [ -f "$KERNEL_CONFIG_FILE" ]; then
            echo "Restoring saved kernel config"
            cp "$KERNEL_CONFIG_FILE" .config
            make olddefconfig
        else
            echo "No saved config found, using defconfig"
            make defconfig
        fi


        if [ -f .config ]; then
            cp .config .config.pre-menuconfig
            echo "Backup saved: .config.pre-menuconfig"
        fi

        make menuconfig
        ;;
    n-interactive)
        echo "Launching kernel nconfig (recommended)"

        if [ -f "$KERNEL_CONFIG_FILE" ]; then
            echo "Restoring saved kernel config"
            cp "$KERNEL_CONFIG_FILE" .config
            make olddefconfig
        else
            echo "No saved config found, using defconfig"
            make defconfig
        fi

        if [ -f .config ]; then
            cp .config .config.pre-nconfig
            echo "Backup saved: .config.pre-nconfig"
        fi

        make nconfig
        ;;
    *)
        echo "Invalid KERNEL_CONFIG_MODE: $KERNEL_CONFIG_MODE"
        exit 1
        ;;
esac

# ------------------------------------------------------
# User Confirmation Block
# ------------------------------------------------------
echo
echo "===================================================="
echo "Kernel build confirmation"
echo
echo "Kernel version : $KERNEL_VERSION"
echo "Config mode    : $KERNEL_CONFIG_MODE"
echo "Config file    : $KERNEL_CONFIG_FILE"
echo "Source dir     : $(pwd)"
echo
echo "Next steps:"
echo "  - make"
echo "  - make modules_install"
echo
read -r -p "Proceed with kernel build? [y/N]: " confirm

if ! [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo
    echo "Build aborted by user."
    echo "Saving current kernel configuration..."

    mkdir -p "$(dirname "$KERNEL_CONFIG_FILE")"

    if [ -f .config ]; then
        cp .config "$KERNEL_CONFIG_FILE"
        echo "Config saved to: $KERNEL_CONFIG_FILE"
    else
        echo "WARNING: No .config found to save"
    fi

    echo "You can resume later using:"
    echo "  $0 reuse"
    echo
    exit 0
fi

echo "===================================================="
echo



# ------------------------------------------------------
# Build kernel
# ------------------------------------------------------
make
make modules_install

# ------------------------------------------------------
# Install kernel artifacts
# ------------------------------------------------------
install -v -m644 arch/x86/boot/bzImage \
    /boot/vmlinuz-${KERNEL_VERSION}-lfs-12.4
install -v -m644 System.map \
    /boot/System.map-${KERNEL_VERSION}
install -v -m644 .config \
    /boot/config-${KERNEL_VERSION}

cp -r Documentation -T /usr/share/doc/linux-${KERNEL_VERSION}

chown -R root:root .

# ------------------------------------------------------
# Save known-good config
# ------------------------------------------------------
mkdir -p "$(dirname "$KERNEL_CONFIG_FILE")"
cp .config "$KERNEL_CONFIG_FILE"

popd
