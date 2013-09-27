#!/usr/bin/env sh

source ./colors.sh
source ./utils.sh

print "${fg[white]}${style[bold]} * Awaiting network connection ..."
wait_for_network

# TODO: Automate block setup?
print "${fg[white]}${style[bold]} * Partition and mount drive configuration at /mnt ..."
read -p "Press any key when done... " -n1 -s

print "${fg[white]}${style[bold]}\n * Building configuration ..."
ask "Hostname (keystone): " keystone KEYSTONE_HOSTNAME
ask "Shell (zsh): " zsh KEYSTONE_SHELL
ask "Console font (Lat2-Terminus16): " Lat2-Terminus16 KEYSTONE_CONSOLE_FONT
ask "Console font map (8859-1_to_uni): " 8859-1_to_uni KEYSTONE_FONT_MAP
ask "Language (en_US.UTF-8): " en_US.UTF-8 KEYSTONE_LANGUAGE
ask "Timezone (US/Pacific): " US/Pacific KEYSTONE_TIMEZONE

print "${fg[white]}${style[bold]} * Showing configuration ..."
echo "Hostname: $KEYSTONE_HOSTNAME"
echo "Shell: $KEYSTONE_SHELL"
echo "Font: $KEYSTONE_CONSOLE_FONT"
echo "Font map: $KEYSTONE_FONT_MAP"
echo "Language: $KEYSTONE_LANGUAGE"
echo "Timezone: $KEYSTONE_TIMEZONE"

print "${fg[white]}${style[bold]} * Installing base system ..."
load 'common/pacman'

print "${fg[white]}${style[bold]} * Generate filesystem information ..."
load 'common/fstab'

print "${fg[white]}${style[bold]} * Activating new environment ..."
load 'common/chroot'

print "${fg[white]}${style[bold]} * Configuring time and date ..."
load 'time/common'
load 'time/network'
