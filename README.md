# Keystone
> Arch Linux automated installation procedure.

## Features
 - Massively **concurrent downloading** of packages during installation through [powerpill][].
 - Extensive **autodetection** of the system and its environment — allows automated installation of video drivers
 - **Modular** architecture — easily add support for more environments through blocks

[powerpill]: https://wiki.archlinux.org/index.php/Powerpill

## Prerequisites
 - Somewhat recent arch linux installation media.
 - Network access.

## Instructions
Boot into the Arch Linux installation media and run the following command:

```sh
wget git.io/dzUzRA -O ks.sh; bash ks.sh
```

## Disclaimer
**Keystone**, while awesome, is definitely in an alpha stage and is largely untested in the wild. Just because the authors have stated that this works in their various environments does not mean it will work in yours. The authors are not responsible if your computer turns into a toaster, fights back, explodes, installs arch linux, achieves sentience, or any variation of *not working* not described thus far.

## What works
 - normal BIOS install with root mounted at /mnt

## What doesn't work
 - auto partition hard drives
 - LVM detection when installing grub
 - UEFI — automated support planned soon
 - The "interface" (the questions) is still fairly fragile; if something breaks -- let us know

## License
Unless otherwise noted, all files contained within this project are liensed under the MIT opensource license. See the included file LICENSE or visit opensource.org for more information.
