#!/usr/bin/env sh

# Export that we require xorg.
export KEYSTONE_XORG=1

# Export default window and login managers.
export KEYSTONE_DEFAULT_WINDOW_MANAGER=mutter
export KEYSTONE_DEFAULT_LOGIN_MANAGER=gdm

_desktop_environment__chroot() {
    # Install the gnome package.
    _install 'gnome' 'gnome-extra'

    # TODO: Perhaps allow the thing to ask what parts of gnome you want.
}
