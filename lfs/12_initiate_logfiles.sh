#!/bin/bash
# ======================================================
#  Script Name: 12_initiate_logfiles.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  Purpose:
#  Usage: bash ./12_initiate_logfiles.sh
# ======================================================

[ "$EUID" -eq 0 ] || { echo "ERROR: Must be run as root"; exit 1; }

# Create log files if missing
touch /var/log/{btmp,lastlog,faillog,wtmp}

# Set ownership and permissions
getent group utmp >/dev/null && chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp