#!/usr/bin/env sh

_bootloader__chroot() {
    # Install the GRUB package.
    # Useful for later going back and re-generating the configuration file.
    _install 'grub'

    # Generate configuration file for GRUB.
    grub-mkconfig -o /boot/grub/grub.cfg
}

_bootloader__post_chroot() {
    # Install the GRUB package.
    _install 'grub'

    # Discern what device /boot is located on.
    # BUG: This procedure will fail if /boot or / is on LVM. There should
    #      be a better way to do this.
    if $(mountpoint $KEYSTONE_MOUNT/boot > /dev/null); then
        export KEYSTONE_DEVICE_MOUNT=$KEYSTONE_MOUNT/boot
    else
        export KEYSTONE_DEVICE_MOUNT=$KEYSTONE_MOUNT
    fi

    export KEYSTONE_DEVICE=$(readlink -e /dev/block/$(mountpoint -d $KEYSTONE_DEVICE_MOUNT | awk -F ':' '{print $1}'):0)

    # Install GRUB to the MBR / GPT disk.
    grub-install --root-directory=$KEYSTONE_MOUNT --boot-directory=$KEYSTONE_MOUNT/boot --target=i386-pc --recheck $KEYSTONE_DEVICE
}
