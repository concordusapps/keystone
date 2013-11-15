#!/usr/bin/env sh

# Export that we require xorg.
export KEYSTONE_XORG=1

# TODO: Export a default login manager.

_window_manager__chroot() {
    # Install the required packages.
    _install 'awesome'

    # Setup initial configuration for awesome.
    mkdir -p /home/$KEYSTONE_USERNAME/.config/awesome/
    cp /etc/xdg/awesome/rc.lua /home/$KEYSTONE_USERNAME/.config/awesome/
}
