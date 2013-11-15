#!/usr/bin/env sh

# Fetch the tarball from github of the latest version of keystone.
wget https://github.com/concordusapps/keystone/archive/master.tar.gz

# Extract keystone and navigate inside.
tar -xzvf master.tar.gz; cd keystone-master

# Execute the install script.
./install.sh
