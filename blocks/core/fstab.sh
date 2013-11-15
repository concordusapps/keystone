#!/usr/bin/env sh

# Generate a fstab file using currently mounted devices.
# -----------------------------------------------------------------------------
# Assumes anything mounted during installation to belong in fstab (
# and auto-mount on boot.)
genfstab -p /mnt >> /mnt/etc/fstab
