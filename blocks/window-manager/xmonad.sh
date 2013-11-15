#!/usr/bin/env sh

# Export that we require xorg.
export KEYSTONE_XORG=1

# TODO: Export a default login manager.

_window_manager__chroot() {
    # Install the required packages.
    _install 'xmonad'
}
