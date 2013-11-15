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

# Install CLI JSON parser
# -----------------------------------------------------------------------------
_install 'jshon'

# Configure powerpill to use the top 10 rsync servers found by
# reflector.
# -----------------------------------------------------------------------------
local servers
servers=`reflector -p rsync -f 15 -l 15 | \
    grep Server | \
    sed \
        -e ':a;N;$!ba;s/\n/ -i append/g' \
        -e 's/Server = / -s /g'`

jshon -e rsync -n array -i servers -p < /etc/powerpill/powerpill.json > /tmp/jshon-$PPID
mv /tmp/jshon-$PPID /etc/powerpill/powerpill.json
jshon -e rsync -e servers $servers -i append -p -p < /etc/powerpill/powerpill.json > /tmp/jshon-$PPID
mv /tmp/jshon-$PPID /etc/powerpill/powerpill.json

# Uninstall CLI JSON parser
# -----------------------------------------------------------------------------
_uninstall 'jshon'
