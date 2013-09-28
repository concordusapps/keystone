#!/usr/bin/env sh

# Base
# -----------------------------------------------------------------------------
for x in ./lib/*; do . $x; done

# Network
# -----------------------------------------------------------------------------
print " * Awaiting network connection ..."
wait_for_network

# Configuration
# -----------------------------------------------------------------------------
# TODO: Attempt to load configuration from a file
print " * Building configuration ..."
ask "Hostname (keystone): " keystone KEYSTONE_HOSTNAME
ask "Shell (zsh): " zsh KEYSTONE_SHELL
ask "Console font (Lat2-Terminus16): " Lat2-Terminus16 KEYSTONE_CONSOLE_FONT
ask "Console font map (8859-1_to_uni): " 8859-1_to_uni KEYSTONE_FONT_MAP
ask "Language (en_US.UTF-8): " en_US.UTF-8 KEYSTONE_LANGUAGE
ask "Timezone (US/Pacific): " US/Pacific KEYSTONE_TIMEZONE
ask "AUR helper (aura): " aura KEYSTONE_AUR_HELPER
# TODO: Write out configuration to a file

# Install base system (outside chroot)
# -----------------------------------------------------------------------------
# TODO: Only perform these steps while outside the chroot

print " * Partition and mount drive configuration at /mnt ..."
read -p "Press any key when done... " -n1 -s

print " * Installing base system ..."
load 'common/base'

print " * Generate filesystem information ..."
load 'common/fstab'

print " * Activating new environment ..."
load 'common/chroot'

# Configure system (inside chroot)
# -----------------------------------------------------------------------------
# TODO: Only perform these steps while inside the chroot

print " * Optimizing pacman ..."
load 'pacman/powerpill'

print " * Configuring time and date ..."
load 'time/common'
load 'time/network'
