#!/bin/bash
# ======================================================
#  Script Name: build-grub.sh
#  Author: Benevant Mathew
#  Created: 2025-12-20
#  LFS: 12.4
#  Purpose: Build grub for LFS
# ======================================================
# configure
PHASE=04-system
PKG=grub

# ======================================================
# stamp block
STAMP_ROOT=/stamps
STAMP_DIR="$STAMP_ROOT/$PHASE"
STAMP="$STAMP_DIR/$PKG.done"


[ -f "$STAMP" ] && {
    echo "$PKG already installed — skipping"
    exit 0
}
# ======================================================
# SAFETY CHECK: Ensure the directory actually exists before proceeding
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory $SRC does not exist."
    exit 1
fi

[ "$(id -u)" -eq 0 ] || {
    echo "ERROR: $PKG must be built as root inside chroot" >&2
    exit 1
}

pushd "$SRC"
###
rm -rf grub-2.12
tar -xvf grub-2.12.tar.xz
cd grub-2.12
###

# BUILD
mkdir -pv /usr/share/fonts/unifont &&
gunzip -c ../unifont-16.0.04.pcf.gz > /usr/share/fonts/unifont/unifont.pcf
echo depends bli part_gpt > grub-core/extra_deps.lst
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --disable-efiemu     \
            --with-platform=efi  \
            --target=x86_64      \
            --disable-werror     &&
make
make install &&
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
install -vm755 grub-mkfont /usr/bin/ &&
install -vm644 ascii.h widthspec.h *.pf2 /usr/share/grub/

# add stamp
mkdir -p "$STAMP_DIR"
touch "$STAMP"

###
cd ..
rm -rf grub-2.12
###
popd
