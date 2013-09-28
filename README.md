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
 - make script that gives the following in the ISO:
    - root password
    - sshd service
    - packaged git
    - packaged repository of keystone
    - packaged powerpill
