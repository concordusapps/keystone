#!/usr/bin/env sh

# Base
# -----------------------------------------------------------------------------

# Discover directory where keystone is located.
export KEYSTONE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source all libraries.
for x in $KEYSTONE_DIR/lib/*.sh; do . $x; done

# Source configuration file if existing.
[[ -f $KEYSTONE_DIR/config.sh ]] && . $KEYSTONE_DIR/config.sh

# Network
# -----------------------------------------------------------------------------
_print " * Awaiting network connection ..."
_wait_for_network

# Static configuration
# -----------------------------------------------------------------------------
export KEYSTONE_MOUNT=/mnt
export KEYSTONE_LC_COLLATE=C

# Dynamic Configuration
# -----------------------------------------------------------------------------
_print " * Building configuration ..."

_ask "Hostname" keystone KEYSTONE_HOSTNAME
_ask "Shell" bash KEYSTONE_SHELL
_ask "Console font" Lat2-Terminus16 KEYSTONE_CONSOLE_FONT
_ask "Console font map" 8859-1_to_uni KEYSTONE_FONT_MAP
_ask "Language" en_US.UTF-8 KEYSTONE_LANGUAGE
_ask "Timezone" US/Pacific KEYSTONE_TIMEZONE
_ask "AUR helper" aura KEYSTONE_AUR_HELPER

# Install base system (outside chroot)
# -----------------------------------------------------------------------------
if [[ -z $KEYSTONE_CHROOT ]]; then

    _print " * Partition and mount drive configuration at /mnt ..."
    read -p "Press any key when done... " -n1 -s
    _print ""

    _print " * Installing base system ..."
    _load 'core/base'

    _print " * Generate filesystem information ..."
    _load 'core/fstab'

    _print " * Activating new environment ..."
    _load 'core/chroot'

fi

# Configure system (inside chroot)
# -----------------------------------------------------------------------------
if [[ $KEYSTONE_CHROOT ]]; then

    _print " * Configuring hostname ..."
    _load 'core/hostname'

    _print " * Configuring locale ..."
    _load 'core/locale'

    _print " * Configuring time and date ..."
    _load 'time/common'
    _load 'time/network'

    _print " * Awaiting network connection ..."
    _wait_for_network

    _print " * Optimizing pacman ..."
    _load 'pacman/powerpill'

    _print " * Configuring virtual console font ..."
    _load 'core/vconsole'

    _print " * Generating initial ramdisk ..."
    _load 'core/mkinitcpio'

    # TODO: password
    # TODO: boot loader

fi
