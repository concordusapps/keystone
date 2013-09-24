#!/usr/bin/env sh

# Update the package repositories and ensure we have network access.
pacman -Syy || exit

# Install the version control system.
pacman -S git || exit

# Fetch this repository.
git clone http://git/stash/scm/cai/keystone.git || exit
