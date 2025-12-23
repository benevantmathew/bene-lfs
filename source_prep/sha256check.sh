#!/bin/bash
# sha256check.sh
# Verify all files using sha256sums file in the script directory

set -euo pipefail

# Configuration
# DOWNLOAD_DIR="/mnt/lfs/sources"   # used initially before chroot
DOWNLOAD_DIR="/sources"             # Directory where source tar files located

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# sha256 file located in script directory
SHA256_FILE="$SCRIPT_DIR/sha256sums"

# Check if sha256sums file exists
if [[ ! -f "$SHA256_FILE" ]]; then
    echo "Error: sha256sums file not found in $SCRIPT_DIR"
    exit 1
fi

echo "Checking SHA256 sums in: $DOWNLOAD_DIR"
echo

# Feed sha256sum modified paths
sed "s#  #  $DOWNLOAD_DIR/#" "$SHA256_FILE" | sha256sum -c -

echo
echo "SHA256 check completed."
