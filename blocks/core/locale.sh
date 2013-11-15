#!/usr/bin/env sh

# Generate locale files for desired locale.
sed -i "s/^#\($KEYSTONE_LANGUAGE.*\)$/\1/" /etc/locale.gen; locale-gen

# Write locale to '/etc/locale.conf'.
echo "LANG=$KEYSTONE_LANGUAGE" >> /etc/locale.conf

# Ensure collation ordering is set to 'C' (for file/folder sorting).
echo "LC_COLLATE=$KEYSTONE_LC_COLLATE" >> /etc/locale.conf
