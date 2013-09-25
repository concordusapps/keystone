#!/usr/bin/env bash
source ./colors.sh
source ./utils.sh

# Gather configuration.
echo ${fg_bold} "* Building configuration..."
ask "Hostname (keystone): " keystone hostname
