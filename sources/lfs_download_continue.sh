#!/bin/bash
# lfs_download_continue.sh
# Download LFS sources, skip already downloaded files, graceful timeout, logging

set -euo pipefail

# Configuration
WGET_LIST="wget-list-sysv"                # Input file with URLs
DOWNLOAD_DIR="/mnt/lfs/sources"          # Directory to save files
LOG_FILE="$DOWNLOAD_DIR/download.log"     # Log successful downloads
ERROR_LOG="$DOWNLOAD_DIR/error.log"       # Log failed downloads

# Create download directory if it doesn't exist
mkdir -p "$DOWNLOAD_DIR"

# Check if wget list file exists
if [[ ! -f "$WGET_LIST" ]]; then
    echo "Error: Wget list file '$WGET_LIST' not found."
    exit 1
fi

echo "Starting downloads..."
echo "Logs:"
echo "  Success: $LOG_FILE"
echo "  Failed:  $ERROR_LOG"

# Download each URL from the list
while IFS= read -r url || [[ -n "$url" ]]; do
    # Skip empty lines or lines starting with #
    [[ -z "$url" || "$url" =~ ^# ]] && continue

    # Extract the filename from URL
    filename=$(basename "$url")
    filepath="$DOWNLOAD_DIR/$filename"

    # Skip if file already exists
    if [[ -f "$filepath" ]]; then
        echo "[SKIPPED] $filename already exists, skipping."
        echo "[SKIPPED] $url" >> "$LOG_FILE"
        continue
    fi

    echo "Downloading: $url"

    # Use wget with:
    # -c : continue partially downloaded files
    # -P : download directory
    # --timeout=10 : 10 sec timeout per connection
    # --tries=2 : try twice per URL
    # --show-progress : show progress bar
    if wget --continue --directory-prefix="$DOWNLOAD_DIR" --timeout=10 --tries=2 --show-progress "$url"; then
        echo "[OK] $url" >> "$LOG_FILE"
    else
        echo "[FAILED] $url" >> "$ERROR_LOG"
        echo "  Failed to download $url, moving on..."
    fi
done < "$WGET_LIST"

echo "Download finished."
echo "Check $LOG_FILE for successful downloads and $ERROR_LOG for failures."

