#!/usr/bin/env sh

# Install the package containing the required driver.
_install 'xf86-video-intel'

# TODO: Add 'i915' to the MODULES array in initcpio.conf
