#!/usr/bin/env sh

# Copy this repository to the new environment.
export KEYSTONE_PATH=$(realpath $(dirname $0))
cp -r $KEYSTONE_PATH $KEYSTONE_MOUNT/root/

# Set that we're in a chroot to the configuration.
echo "export KEYSTONE_CHROOT=1" >> "$KEYSTONE_MOUNT/root/$(basename $KEYSTONE_PATH)/config.sh"

# Switch to new environment and run the install script.
arch-chroot $KEYSTONE_MOUNT "/root/$(basename $KEYSTONE_PATH)/install.sh"
