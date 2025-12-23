#!/bin/bash
# ======================================================
#  Script Name: 18_chapter9_config.sh
#  Author: Benevant Mathew
#  Created: 2025-12-22
#  Purpose:
# files updated
# - /etc/sysconfig/ifconfig.${IFACE}
# - /etc/resolv.conf
# - /etc/hostname
# - /etc/hosts
# - /etc/inittab
# - /etc/sysconfig/clock
# - /etc/sysconfig/console
# - /etc/profile
# - /etc/inputrc
# - /etc/shells
# ======================================================
set -euo pipefail

# ======================================================
# CONFIGURATION (edit once, reuse everywhere)
# ======================================================

HOSTNAME="build1"
IFACE="enp9s0"

IPADDR="192.168.1.11"
GATEWAY="192.168.1.1"
PREFIX="24"
BROADCAST="192.168.1.255"

DNS1="8.8.8.8"
DNS2="1.1.1.1"

# ======================================================
# Network configuration
# ======================================================

cat > "/etc/sysconfig/ifconfig.${IFACE}" << EOF
ONBOOT=yes
IFACE=${IFACE}
SERVICE=ipv4-static
IP=${IPADDR}
GATEWAY=${GATEWAY}
PREFIX=${PREFIX}
BROADCAST=${BROADCAST}
EOF

cat > /etc/resolv.conf << EOF
# Begin /etc/resolv.conf

nameserver ${DNS1}
nameserver ${DNS2}

# End /etc/resolv.conf
EOF

# ======================================================
# Hostname and hosts
# ======================================================

echo "${HOSTNAME}" > /etc/hostname

cat > /etc/hosts << EOF
# Begin /etc/hosts

127.0.0.1 localhost
127.0.1.1 ${HOSTNAME}
::1       localhost

# End /etc/hosts
EOF

# ======================================================
# SysV init configuration
# ======================================================

cat > /etc/inittab << "EOF"
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S06:once:/sbin/sulogin
s1:1:respawn:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600

# End /etc/inittab
EOF

# ======================================================
# Clock & console
# ======================================================

cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=1

# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=

# End /etc/sysconfig/clock
EOF

cat > /etc/sysconfig/console << "EOF"
# Begin /etc/sysconfig/console

UNICODE="1"
FONT="Lat2-Terminus16"

# End /etc/sysconfig/console
EOF

# ======================================================
# Profile & input
# ======================================================

cat > /etc/profile << "EOF"
# Begin /etc/profile

for i in $(locale); do
    unset ${i%=*}
done

if [[ "$TERM" = linux ]]; then
    export LANG=C.UTF-8
else
    export LANG=en_IN.UTF-8
fi

# End /etc/profile
EOF

cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8-bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF

cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

echo "Chapter 9 configuration completed successfully."