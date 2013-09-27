#!/usr/bin/env sh

cp /etc/pacman.d/mirrorlist{,.bak}

rankmirrors -n 6 /etc/pacman.d/mirrorlist.bak > /etc/pacman.d/mirrorlist

pacstrap /mnt base base-devel

cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
