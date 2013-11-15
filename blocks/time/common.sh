#!/usr/bin/env sh

# This will create an '/etc/localtime' symlink that points to a
# zoneinfo file under '/usr/share/zoneinfo/'.
timedatectl set-timezone $KEYSTONE_TIMEZONE
