#!/usr/bin/env sh

# Set that we're in a chroot to the configuration.
echo "export KEYSTONE_CHROOT=1" >> ./config.sh

# Copy this repository to the new environment.
cp -r $(realpath $(dirname $0)) $KEYSTONE_MOUNT/root/

# Switch to new environment and run the install script.
arch-chroot $KEYSTONE_MOUNT "/root/keystone/install.sh"
