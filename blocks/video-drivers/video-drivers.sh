#!/usr/bin/env sh

#Install vesa... just in case.
_print 'installing vesa'
_install 'xf86-video-vesa'

_print 'checking if video drivers for intel need to be installed'
lspci | grep VGA | grep Intel && _install xf86-video-intel

#Lets hope the following works

_print 'checking if video drivers for ATI need to be installed'
lspci | grep VGA | grep -i ati && _install xf86-video-ati