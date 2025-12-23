#!/bin/bash
# ======================================================
#  Script Name: 10_compile_tools.sh
#  Author: Benevant Mathew
#  Created: 2025-12-14
#  Purpose:
#  source "scripts/lfs/utils/config.sh" first
# ======================================================

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils/config.sh"
source "$SCRIPT_DIR/utils/require.sh"

# ======================================================

require man_pages
require iana_etc
require glibc
require zlib
require bzip2
require xz
require lz4
require zstd
require file
require readline
require m4
require bc
require flex
require tcl
require expect
require dejagnu
require pkgconf
require binutils
require gmp
require mpfr
require mpc
require attr
require acl
require libcap
require libxcrypt
require shadow
require gcc
require ncurses
require sed
require psmisc
require gettext
require bison
require grep
require bash
require libtool
require gdbm
require gperf
require expat
require inetutils
require less
require perl
require xml_parser
require intltool
require autoconf
require automake
require openssl
require libelf_elfutils
require libffi
require python
require flit_core
require packaging
require wheel
require setuptools
require ninja
require meson
require kmod
require coreutils
require diffutils
require gawk
require findutils
require groff
require efivar
require popt
require efibootmgr
require freetype
require grub
require gzip
require iproute2
require kbd
require libpipeline
require make
require patch
require tar
require texinfo
require vim
require markupsafe
require jinja2
require udev_systemd
require man_db
require procps_ng
require util_linux
require e2fsprogs
require sysklogd
require sysvinit
