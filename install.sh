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
export KEYSTONE_DEFAULT_NETWORK_MANAGER=wicd

# Dynamic Configuration
# -----------------------------------------------------------------------------
_print " * Building configuration ..."

_ask "Hostname" keystone KEYSTONE_HOSTNAME
_ask "Shell" bash KEYSTONE_SHELL
_ask "Console font" Lat2-Terminus16 KEYSTONE_CONSOLE_FONT
_ask "Console font map" 8859-1_to_uni KEYSTONE_FONT_MAP
_ask "Language" en_US.UTF-8 KEYSTONE_LANGUAGE
_ask "Timezone" US/Pacific KEYSTONE_TIMEZONE
_ask "Username" administrator KEYSTONE_USERNAME
_ask "AUR helper" aura KEYSTONE_AUR_HELPER
_ask "Bootloader" grub KEYSTONE_BOOTLOADER

_ask "Desktop Environment" none KEYSTONE_DESKTOP_ENVIRONMENT
_load "desktop-environment/$KEYSTONE_DESKTOP_ENVIRONMENT"

_ask "Window Manager" ${KEYSTONE_DEFAULT_WINDOW_MANAGER:-none} KEYSTONE_WINDOW_MANAGER
_load "window-manager/$KEYSTONE_WINDOW_MANAGER"

if [ $KEYSTONE_WINDOW_MANAGER != 'none' ]; then
    _ask "Login Manager" ${KEYSTONE_DEFAULT_LOGIN_MANAGER:-none} KEYSTONE_LOGIN_MANAGER
    _load "login-manager/$KEYSTONE_LOGIN_MANAGER"
fi

_ask "Network Manager" $KEYSTONE_DEFAULT_NETWORK_MANAGER KEYSTONE_NETWORK_MANAGER

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

    _print " * Adding normal user ..."
    _load 'core/user'

    if [[ -n $KEYSTONE_XORG ]]; then
        _print " * Configuring display drivers ..."
        _load 'xorg/xorg-server'

        _print " * Installing desktop environment ..."
        _desktop_environment__chroot
        _window_manager__chroot
        _login_manager__chroot
    fi

    _print " * Installing network management utilities ..."
    _load 'network/common'
    _load "network/$KEYSTONE_NETWORK_MANAGER"

    _print " * Installing bootloader in new environment ..."
    _bootloader__chroot

fi

# Post-configure Install (outside chroot)
# -----------------------------------------------------------------------------
if [[ -z $KEYSTONE_CHROOT ]]; then

    _print " * Installing bootloader on device..."
    _bootloader__post_chroot

    _print " * Cleaning up..."
    rm -rf "/root/$(basename $(realpath $(dirname $0)))"

    _countdown 10 "Rebooting"
    reboot

fi
