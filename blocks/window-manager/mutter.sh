#!/usr/bin/env sh

# Export that we require xorg.
export KEYSTONE_XORG=1

_window_manager__chroot() {
    # Not supported unless used with gnome; in which case gnome has
    # already installed us.
    :
}
