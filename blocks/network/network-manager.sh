#!/usr/bin/env sh

# Install the required packages.
_install 'networkmanager'

# Enable the service.
systemctl enable NetworkManager
