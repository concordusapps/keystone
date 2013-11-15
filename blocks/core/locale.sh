#!/usr/bin/env sh

# Generate locale files for desired locale.
sed -i "s/^#\($KEYSTONE_LANGUAGE.*\)$/\1/" /etc/locale.gen; locale-gen

# Write locale to '/etc/locale.conf'.
localectl set-locale LANG=$KEYSTONE_LANGUAGE

# Ensure collation ordering is set to 'C' (for file/folder sorting).
localectl set-locale LC_COLLATE=$KEYSTONE_LC_COLLATE
