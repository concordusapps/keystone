# Keystone
> Arch Linux automated install procedure

## Prerequisites
 - somewhat recent arch linux installation media
 - network access
 - git

## Instructions
Boot into the Arch Linux installation media and run the following commands:

```sh
# Install git.
$ pacman -Sy git --noconfirm

# Clone the repository (this will ask for your LDAP username and password).
$ git clone http://git/stash/scm/cai/keystone.git

# Navigate to and execute the install script.
$ cd keystone
$ sh ./install.sh
```

## Roadmap
 - package script that gives the following in the ISO:
    - root password
    - sshd service
    - packaged git
    - packaged repository of keystone
    - packaged powerpill

 - core/chroot needs to re-execute the install.sh script
 - install.sh needs to lock down pre/post chroot in if blocks that detect chroot
 - install.sh needs to store / reload config and only ask user if file isn't found
 - 100% remote access (no git; just curl) .. it might reduce invocation burden
