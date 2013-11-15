#!/usr/bin/env sh

# Install the required packages.
_install 'wicd'

# Enable the service.
systemctl enable wicd

