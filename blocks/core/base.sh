#!/usr/bin/env sh

# Optimize
# -----------------------------------------------------------------------------
cp /etc/pacman.d/mirrorlist{,.bak}
rankmirrors -n 6 /etc/pacman.d/mirrorlist.bak > /etc/pacman.d/mirrorlist

# Install powerpill
# -----------------------------------------------------------------------------
# This allows us to fetch all packages concurrently during the pacstrap.
_install_aur_manual 'pm2ml'
_install_aur_manual 'powerpill'

# Fetch all packages (concurrently) using powerpill
# -----------------------------------------------------------------------------
powerpill -Syy --downloadonly --noconfirm -r $KEYSTONE_MOUNT base base-devel

# Bootstrap
# -----------------------------------------------------------------------------
pacstrap /mnt base base-devel
