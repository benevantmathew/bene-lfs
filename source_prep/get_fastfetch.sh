#!/bin/bash
# ======================================================
#  Script Name: get_fastfetch.sh
#  Author: Benevant Mathew
#  Created: 2025-12-23
#  LFS: 12.4
#  Purpose: Download fastfetch source tarball
# ======================================================

set -euo pipefail

FASTFETCH_VER="2.56.1"

DOWNLOAD_DIR="/sources"

URL="https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/${FASTFETCH_VER}.tar.gz"

RAW_FILENAME="${FASTFETCH_VER}.tar.gz"
RAW_FILEPATH="${DOWNLOAD_DIR}/${RAW_FILENAME}"

STD_FILENAME="fastfetch-${FASTFETCH_VER}.tar.gz"
STD_FILEPATH="${DOWNLOAD_DIR}/${STD_FILENAME}"

mkdir -p "$DOWNLOAD_DIR"

echo "Downloading fastfetch ${FASTFETCH_VER}..."

if [[ -f "$STD_FILEPATH" ]]; then
    echo "[SKIPPED] ${STD_FILEPATH} already exists."
    exit 0
fi

wget \
    --continue \
    --directory-prefix="$DOWNLOAD_DIR" \
    --timeout=10 \
    --tries=2 \
    --show-progress \
    "$URL"

# Rename to LFS-standard filename
mv -f "$RAW_FILEPATH" "$STD_FILEPATH"

echo "Download completed: ${STD_FILEPATH}"
