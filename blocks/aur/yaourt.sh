#!/usr/bin/env sh

# Add archlinuxfr repository to easily fetch yaourt.
# -----------------------------------------------------------------------------
_repo 'archlinuxfr'

# Install yaourt plus various helpers.
# -----------------------------------------------------------------------------
_install 'yaourt' 'rsync'
