#!/usr/bin/env sh

ln -sf /usr/share/zoneinfo/${KEYSTONE_TIMEZONE} /etc/localtime

echo $KEYSTONE_TIMEZONE > /etc/timezone
