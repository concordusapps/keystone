#!/usr/bin/env sh

# Write out vconsole font and font map configuration.
echo "FONT=$KEYSTONE_CONSOLE_FONT" >> /etc/vconsole.conf
echo "FONT_MAP=$KEYSTONE_FONT_MAP" >> /etc/vconsole.conf
