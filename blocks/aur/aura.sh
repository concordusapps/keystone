#!/usr/bin/env sh

# Add haskell repositories to more easily fetch aura.
# -----------------------------------------------------------------------------
_repo 'haskell-core'
_repo 'haskell-extra'

# Install aura plus various helpers.
# -----------------------------------------------------------------------------
_install_aur 'aura'
_install 'rsync'
