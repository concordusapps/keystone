#!/usr/bin/env sh

# Write hostname to '/etc/hostname'.
echo $KEYSTONE_HOSTNAME > /etc/hostname

# Replace 'localhost.localdomain' in /etc/hosts with the configured hostname.
sed -i "s/localhost\.localdomain/$KEYSTONE_HOSTNAME/g" /etc/hosts
