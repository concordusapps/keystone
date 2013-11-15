#!/usr/bin/env sh

# Install the GRUB package.
_install 'grub'

# Discern what device /boot is located on.
if $(mounpoint $KEYSTONE_MOUNT/boot > /dev/null); then
    export KEYSTONE_DEVICE_MOUNT=$KEYSTONE_MOUNT/boot
else
    export KEYSTONE_DEVICE_MOUNT=$KEYSTONE_MOUNT
fi

export KEYSTONE_DEVICE=$(cat /etc/mtab | awk -v m=/ '{  if ($2 == m) print $1 }')

# Install GRUB to the MBR / GPT disk.
grub-install --root-directory=$KEYSTONE_MOUNT --boot-directory=$KEYSTONE_MOUNT/boot --target=i386-pc --recheck --debug $KEYSTONE_DEVICE
