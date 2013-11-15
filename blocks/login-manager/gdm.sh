#!/usr/bin/env sh

_login_manager__chroot() {
    # Install the required package.
    _install 'gdm'

    # Enable the service.
    systemctl enable gdm
}
