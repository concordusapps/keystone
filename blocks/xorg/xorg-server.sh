#!/usr/bin/env sh

# install X window
_print  '** - - -installing X - - -'
_install ' xorg-server xorg-server-utils xorg-xinit'

# Install mesa
_print' Installing mesa for 3d support'
_install 'mesa'



