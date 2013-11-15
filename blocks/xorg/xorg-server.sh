#!/usr/bin/env sh

# Isntall 'xorg-server' and its utilities package.
_install 'xorg-server' 'xorg-server-utils'

# Install 'mesa' for fun.
_install 'mesa'

# Install a fallback video driver (just in case).
_install 'xf86-video-vesa'

# Detect and load an appropriate video card driver.
for vendor in (intel ati nvidia via); do
    if $(lspci -s 02 -vmm | grep -e ^Vendor: | grep -i $vendor); then
        _load "driver/video/$vendor"
        break
    fi
done
