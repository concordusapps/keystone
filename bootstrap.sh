#!/usr/bin/env sh

# Update the package repositories and ensure we have network access.
pacman -Syy || exit

# Install the version control system.
pacman -S git

# Fetch this repository.
git clone https://git/CAI/keystone.git /tmp/keystone
