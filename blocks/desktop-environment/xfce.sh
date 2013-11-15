#!/usr/bin/env sh

# Export that we require xorg.
export KEYSTONE_XORG=1

# TODO: Export default window and login managers.

_desktop_environment__chroot() {
    # Install the required packages.
    _install 'xfce4' 'xfce4-goodies'

    # TODO: Perhaps allow the thing to ask what parts of xfce4 you want.
}
