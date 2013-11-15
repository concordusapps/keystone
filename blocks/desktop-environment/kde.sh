#!/usr/bin/env sh

# Export that we require xorg.
export KEYSTONE_XORG=1

# TODO: Export default window and login managers.

_desktop_environment__chroot() {
    # Install the required meta-package.
    _install 'kde-meta'
}
