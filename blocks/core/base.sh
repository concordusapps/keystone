#!/usr/bin/env sh

# Install powerpill
# -----------------------------------------------------------------------------
# This allows us to fetch all packages concurrently during the pacstrap.
_install 'binutils'
_install_aur_manual 'pm2ml'
_install_aur_manual 'powerpill'

# Optimize
# -----------------------------------------------------------------------------
# Ensure we have the fatest and most-up-to-date mirrors.
reflector -f 10 -l 10 > /etc/pacman.d/mirrorlist

# Create required directories
# -----------------------------------------------------------------------------
# This is normally done by pacstrap but we're being interesting and using
# powerpill.
mkdir -m 0755 -p "$KEYSTONE_MOUNT"/var/{cache/pacman/pkg,lib/pacman,log} "$KEYSTONE_MOUNT"/{dev,run,etc}
mkdir -m 1777 -p "$KEYSTONE_MOUNT"/tmp
mkdir -m 0555 -p "$KEYSTONE_MOUNT"/{sys,proc}

# Fetch all packages (concurrently) using powerpill
# -----------------------------------------------------------------------------
powerpill -Syy --downloadonly --noconfirm -r $KEYSTONE_MOUNT base base-devel

# Copy downloaded package cache to the new mount.
# -----------------------------------------------------------------------------
# NOTE: This shouldn't be neccessary.. there seems to be a bug with the
#       invocation of powerpill above.
cp /var/cache/pacman/pkg/* /mnt/var/cache/pacman/pkg

# Bootstrap
# -----------------------------------------------------------------------------
pacstrap /mnt base base-devel
