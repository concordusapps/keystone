#!/usr/bin/env sh

# Add normal user account.
# Define method to add hooks before a hook to the mkinitcpio configuration.
useradd -m -s /bin/bash -g users $KEYSTONE_USERNAME

# Set the password.
passwd $KEYSTONE_USERNAME
