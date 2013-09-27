#!/usr/bin/env sh

yaourt -S ntp --noconfirm

systemctl enable ntpd.service

ntpd -q

hwclock --systohc --utc
