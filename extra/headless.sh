#!/usr/bin/env bash

# Headless v0.1.0
# -----------------------------------------------------------------------------
# Modifies an Arch Linux installation ISO to allow remote installation.
#   - Changes the root password from nothing to 'keystone'.
#   - Configures ssh to autostart.
#   - Includes git.

# Prerequisites
# -----------------------------------------------------------------------------
[ -z $(which unsquashfs) ] && echo "error: requires squashfs-tools"
[ -z $(which genisoimage) ] && echo "error: requires cdrkit"

# Usage
# -----------------------------------------------------------------------------
function usage {
    echo "headless [-a 32/64] arch.iso"
}

# #!/usr/bin/bash
# # by wm/wiemag/dif 2013-09-09
# # ---==== INSTALL ARCH LINUX ON A HEADLESS SERVER ====-------------------------
# # How to remaster arch.iso image so that it starts automatically, allowing an ssh-administered ("blind") installation of a headless server.
# # Assumptions about the computer system arch linux will be installed on:
# # - it boots from a CD/DVD first
# # - it is connected to the local network
# # Currently, the official installation media start with the ssh daemon down.
# # v0.95 first published
# # v0.96 check if squashfs-toosi and cdrkit are installed; If not, ask whether to install.

# VERSION=0.96


# # Declarations and initialisation ---------------
# function usage() {
#     echo -e "\n\e[1march-headless [ -a 32 | 64 ] arch.iso | -h\e[0m\n"
#     echo -e "\tarch.iso - path to arch-install-media.iso"
#     echo -e "\t           e.g. archlinux-2013.09.01-dual.iso"
#     echo -e "\t           or /path/to/archlinux-2013.09.01-dual.iso"
#     echo -e "\t-a 32 - install a 32-bit system (default)"
#     echo -e "\t-a 64 - install a 64-bit system\n"
# }

# while getopts  ":a:hv" flag
# do
#     case "$flag" in
#         h) usage && exit;;
#         v) echo -e "\n${0##*/} v.${VERSION}"; exit;;
#         a) ARCH="$OPTARG";;
#     esac
# done

# # Remove the options parsed above.
# shift `expr $OPTIND - 1`
# ISO="$1"        # Path/name of the official arch installation iso image
# ((${#ISO})) || { usage; echo -e "\e[1mMissing parameter.\e[0m"; exit;}
# if [ -f "$ISO" ]; then
#     path=${ISO%/*}
#     [[ -z $path ]] && path=$(pwd)
# else
#     usage
#     echo -e "\e[31;1m${ISO}\e[0m not found."
#     exit 1
# fi

# # START -----------------------------------------

# [[ -d /mnt/archiso ]] || sudo mkdir /mnt/archiso
# [[ -d /mnt/rootfs ]] || sudo mkdir /mnt/rootfs
# (( $(echo $(grep /mnt/archiso /etc/mtab)|wc -w) )) || \
#     sudo mount -t iso9660 -o loop "$ISO" /mnt/archiso
# echo -e "\nCopying ${ISO##*/}\n\tto ${path}/archiso"
# cp -a /mnt/archiso "$path"/

# echo "Modifying /mnt/archiso/arch/boot/syslinux/archiso.cfg"
# echo -e "\tto log in automatically."

# ARCH=${ARCH-32}                 # A 32-bit sistem as the default one.
# [[ $ARCH -lt 50 ]] && ARCH="i686" || ARCH="x86_64"

# sudo echo -e "PROMPT 0\nDEFAULT arch-${ARCH}\nLABEL arch-${ARCH}
# LINUX boot/${ARCH}/vmlinuz\nINITRD boot/${ARCH}/archiso.img
# APPEND archisobasedir=arch archisolabel=ARCH_$(date +%Y%m)" > \
#     "$path"/archiso/arch/boot/syslinux/archiso.cfg

# echo "Modifying ...archiso/arch/${ARCH}/root-image.fs.sfs"
# echo -e "\tto start sshd.service at boot."

# cp -a /mnt/archiso/arch/${ARCH}/root-image.fs.sfs /tmp/
# # Install package 'squashfs-tools'
# unsquashfs -d "$path/archiso-${ARCH}-rootfs" /tmp/root-image.fs.sfs
# rm /tmp/root-image.fs.sfs
# (( $(echo $(grep /mnt/rootfs /etc/mtab)|wc -w) )) || \
#     sudo mount "$path/archiso-${ARCH}-rootfs/root-image.fs" /mnt/rootfs
# #--------------------------------------------------------------------
# # Copy the 'arch-chroot' script to your computer. It comes in handy.
# #cp -f /mnt/rootfs/usr/bin/arch-chroot "$path"/
# #sudo chmod a+x "${path}/arch-chroot"
# #--------------------------------------------------------------------

# # Warunek:  Czy istnieje /usr/lib/systemd/system/sshd.service?
# # Tak, pod archlinuksem istnieje!
# sudo ln -s /usr/lib/systemd/system/sshd.service /mnt/rootfs/etc/systemd/system/multi-user.target.wants/

# # Allow empty passwords for sshd
# sudo sed -i 's/#PermitEmpty.*/PermitEmptyPasswords yes/;' /mnt/rootfs/etc/ssh/sshd_config

# # Squash rootfs back
# sudo umount /mnt/rootfs
# mksquashfs "${path}/archiso-${ARCH}-rootfs" /tmp/root-image.fs.sfs
# mv -f /tmp/root-image.fs.sfs "${path}/archiso/arch/${ARCH}/root-image.fs.sfs"

# # Create a modified arch-installation-media.iso
# genisoimage -l -r -J -V "ARCH_$(date +%Y%m)" -b isolinux/isolinux.bin \
#     -no-emul-boot -boot-load-size 4 -boot-info-table -c isolinux/boot.cat \
#     -o "${path}/arch-$(date +%y.%m.%d-%H%M)-custom.iso" "${path}/archiso"
# (($?)) || \
#     echo -e "\e[32;1m${path}/arch-$(date +%y.%m.%d-%H%M)-custom.iso\e[0m has been created."
# echo -n "Cleaning... "
# sudo umount /mnt/archiso
# rm -r "${path}/archiso-${ARCH}-rootfs"
# rm -r "${path}/archiso"
# sudo rm -r /mnt/archiso
# sudo rm -r /mnt/rootfs
# echo "Done."
