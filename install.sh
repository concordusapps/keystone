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
_ask "Bootloader" grub KEYSTONE_BOOTLOADER

# Load deferred blocks
# -----------------------------------------------------------------------------
_load "bootloader/$KEYSTONE_BOOTLOADER"

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

    _print " * Setting root password ..."
    passwd

    _print " * Installing bootloader in new environment ..."
    _bootloader_chroot

fi

# Post-configure Install (outside chroot)
# -----------------------------------------------------------------------------
if [[ -z $KEYSTONE_CHROOT ]]; then

    _print " * Installing bootloader on device..."
    _bootloader_post_chroot

    _countdown 10 "Installation completed successfully; rebooting"
    reboot

fi
##
#Install xorg
#----------------------------------------------------------------
_print 'installing X11....'
_load 'xorg/xorg-server'

##
# Configure video drivers
#------------------------------------------------------------------
_print 'Configuring video drivers....'
_load 'video-drivers/video-drivers'

##
# Configure WM
#-----------------------------------------------------------------

# just going to leave it as openbox for now, until we can verify it works
if _yn 'Would you like to use OpenBox as your Window Manager? [Y/n]' Y  ; then
    _load 'window-manager/openbox'
fi

##
# Desktop Manager configuration
# -----------------------------------------------------------------

#until we finish testing, gnome is all you get.
if _yn "Would you like to use gnome?" Y; then
    _load 'DM/gnome'
fi