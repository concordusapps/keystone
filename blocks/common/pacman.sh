#!/usr/bin/env sh

rankmirrors -n 6 /etc/pacman.d/mirrorlist > /etc/pacman.d/mirrorlist

pacstrap /mnt base base-devel
