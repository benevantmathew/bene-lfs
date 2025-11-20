#/bin/bash
# md5check.sh
# Verify all files using md5sums file in the script directory

set -euo pipefail

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MD5_FILE="$SCRIPT_DIR/md5sums"

# Check if md5sums file exists
if [[ ! -f "$MD5_FILE" ]]; then
    echo "Error: md5sums file not found in $SCRIPT_DIR"
    exit 1
fi

echo "Checking MD5 sums in: $SCRIPT_DIR"
echo

# Run md5sum -c on the md5sums file
# -c checks all files listed
# We run it inside the script directory
(
    cd "$SCRIPT_DIR"
    md5sum -c md5sums
)

echo
echo "MD5 check completed."

