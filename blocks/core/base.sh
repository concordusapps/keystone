#!/usr/bin/env sh

# Optimize
# -----------------------------------------------------------------------------
# TODO: Check for reflector and do this else just rankmirrors
# reflector -f 15 -l 15 > /etc/pacman.d/mirrorlist

cp /etc/pacman.d/mirrorlist{,.bak}

rankmirrors -n 6 /etc/pacman.d/mirrorlist.bak > /etc/pacman.d/mirrorlist

# Bootstrap
# -----------------------------------------------------------------------------
pacstrap /mnt base base-devel
