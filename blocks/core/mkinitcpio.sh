#!/usr/bin/env sh

# Define method to add hooks before a hook to the mkinitcpio configuration.
_add_hook_before() {
    sed -i -e "/^$1/$2 $1/s" -e //N -e //N /etc/mkinitcpio.conf
}

# Define method to add hooks after a hook to the mkinitcpio configuration.
_add_hook_after() {
    sed -i -e "/^$1/$1 $2/s" -e //N -e //N /etc/mkinitcpio.conf
}

# Check if we need to include the 'lvm2' hook.
# If there are any active logical volumes; assume we do.
if [ -z $(lvs 2> /dev/null | wc -l) ]; then
    export KEYSTONE_LVM=1
    _add_hook_before 'filesystems', 'lvm2'
else
    export KEYSTONE_LVM=0
fi

# Check if we need to include the 'usr' or 'shutdown' hooks.
# We need to include then if we included the 'lvm2' hook or if /usr is on
# a separate partition then /root.
if ($(mountpoint /usr > /dev/null) || [ $KEYSTONE_LVM -eq 1 ]); then
    _add_hook_before 'fsck', 'usr'
    _add_hook_after 'fsck', 'shutdown'
fi

# Uncomment the compression option.
sed -i "s/^#\(COMPRESSION=\"xz\".*\)$/\1/" /etc/mkinitcpio.conf

# Generate the ramdisk.
mkinitcpio -p linux
