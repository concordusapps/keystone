#!/usr/bin/env sh

# This will create an '/etc/localtime' symlink that points to a
# zoneinfo file under '/usr/share/zoneinfo/'.
ln -sv ../usr/share/zoneinfo/$KEYSTONE_TIMEZONE /etc/localtime
