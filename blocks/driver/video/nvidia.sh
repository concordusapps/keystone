#!/usr/bin/env sh

# Install the package containing the required driver.
_install 'xf86-video-nouveau'

# TODO: Add the hook to the MODULES array in initcpio.conf
# TODO: Decide (ask?) if we should use the proprietary driver.
