#!/usr/bin/env sh

# Install NTP; available in offical repositories.
_install 'ntp'

# Enable the NTP service.
# Ensure the date/time are periodically synchronized.
systemctl enable ntpd

# Peform an initial synchronization.
ntpd -q

# Write the time to the hardware clock.
hwclock --systohc --utc
