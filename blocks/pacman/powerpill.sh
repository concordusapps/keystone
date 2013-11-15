#!/usr/bin/env sh

# Powerpill is a Pacman wrapper that uses parallel and segmented
# downloading to try to speed up downloads for Pacman.
# -----------------------------------------------------------------------------
# Somehow this magic works with both yaourt and aura.

# Install powerpill from the AUR.
# -----------------------------------------------------------------------------
_install 'rsync'
_install_aur 'powerpill'

# Reconfigure mirrorlist with reflector.
# This grabs the latest mirrorlist and then trims it to 15 of the fastest ones.
# -----------------------------------------------------------------------------
reflector -f 15 -l 15 > /etc/pacman.d/mirrorlist
