#!/bin/bash
# md5check.sh
# Verify all files using md5sums file in the script directory

set -euo pipefail

# Configuration
# DOWNLOAD_DIR="/mnt/lfs/sources" # used initailly before chroot
DOWNLOAD_DIR="/sources"             # Directory where source tar files located

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# md5 file located in script directory
MD5_FILE="$SCRIPT_DIR/md5sums"

# Check if md5sums file exists
if [[ ! -f "$MD5_FILE" ]]; then
    echo "Error: md5sums file not found in $SCRIPT_DIR"
    exit 1
fi

echo "Checking MD5 sums in: $DOWNLOAD_DIR"
echo

# Feed md5sum modified paths
sed "s#  #  $DOWNLOAD_DIR/#" "$MD5_FILE" | md5sum -c -

echo
echo "MD5 check completed."

