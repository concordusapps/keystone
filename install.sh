#!/usr/bin/env sh

# Base
# -----------------------------------------------------------------------------
for x in ./lib/*.sh; do . $x; done

# Network
# -----------------------------------------------------------------------------
_print " * Awaiting network connection ..."

_wait_for_network

# Configuration
# -----------------------------------------------------------------------------
# TODO: Attempt to load configuration from a file

_print " * Building configuration ..."

_ask "Hostname (keystone): " keystone KEYSTONE_HOSTNAME
_ask "Shell (bash): " bash KEYSTONE_SHELL
_ask "Console font (Lat2-Terminus16): " Lat2-Terminus16 KEYSTONE_CONSOLE_FONT
_ask "Console font map (8859-1_to_uni): " 8859-1_to_uni KEYSTONE_FONT_MAP
_ask "Language (en_US.UTF-8): " en_US.UTF-8 KEYSTONE_LANGUAGE
_ask "Timezone (US/Pacific): " US/Pacific KEYSTONE_TIMEZONE
_ask "AUR helper (aura): " aura KEYSTONE_AUR_HELPER

# TODO: Write out configuration to a file

# Install base system (outside chroot)
# -----------------------------------------------------------------------------
# TODO: Only perform these steps while outside the chroot

_print " * Partition and mount drive configuration at /mnt ..."
read -p "Press any key when done... " -n1 -s

_print "\n * Installing base system ..."
_load 'core/base'

_print " * Generate filesystem information ..."
_load 'core/fstab'

_print " * Activating new environment ..."
_load 'core/chroot'

# Configure system (inside chroot)
# -----------------------------------------------------------------------------
# TODO: Only perform these steps while inside the chroot

_print " * Optimizing pacman ..."
_load 'pacman/powerpill'

_print " * Configuring time and date ..."
_load 'time/common'
_load 'time/network'
