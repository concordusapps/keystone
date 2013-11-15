#!/usr/bin/env sh

_print 'installing openbox'
_install 'openbox'

_print 'configuring openbox'
mkdir -p ~/.config/openbox
cp /etc/xdg/openbox/{rc.xml,menu.xml,autostart,environment} ~/.config/openbox
