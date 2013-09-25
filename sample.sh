#!/bin/bash
#
# myArchbyhand-02-install.systemd.64SSDx3.sh
#

# This script is designed to be run in conjunction with a UEFI boot using
# Archboot install media. It is a modification of

#          https://bbs.archlinux.org/viewtopic.php?id=129885

# --append-binary-args is explained here

#          https://bbs.archlinux.org/viewtopic.php?pid=1090040#p1090040

# It is up to you to install applications and users of your choosing.
# I use scripts to automate this but the choice of apps and user configuration
# are my personal references and I don't assume your preferences are the same.

# Things you need to know:

# You should have already created the encrypted RAID array and the LVM2 volumes.
# This script will assemble and decrypt the array and activate the LVM2 volumes.

# Store this script on the device you have extracted the Archboot ios image to
# and intend to boot from in UEFI mode.

# Mount the boot device on /tmp/src so you can access the script.

# You may need to stop your RAID arrays before you run this scrip if they are
# automatically started with arbitrary device names.

mdadm --stop /dev/md126
mdadm --stop /dev/md127

# You should edit /etc/mdadm.conf to remove any RAID devices they you do not
# want activated when you boot into the new install.

# You can use a simple search and replace in your favourite text editor to change these values:

# The Archboot install media is mounted on: /tmp/src
#           The target media is mounted on: /tmp/target
#                      UEFI boot partition: /dev/sda1
#                             RAID devices: /dev/sda2 /dev/sdb2 /dev/sdc2
#                              RAID0 array: /dev/md2
#                     LVM2 physical volume: pv64SSDx3
#                        LVM2 volume group: vg64SSDx3
#             LVM2 logical volume for root: lvRoot
#             LVM2 logical volume for data: lvMyStuff

                                  HOSTNAME="KairiTech-TO"
                                UEFI_LABEL="-=[Arch]=-"

# TIP:
# If you issue the command 'script /tmp/src/install.log' before you run this script
# you will capture all of its screen output.
# It may be useful for debugging but don't forget to 'exit' when the script is
# complete so that it will close the logfile properly so you don't loose any of the details.

clear

echo -en "\n||||||||||     Choose keyboard and console font \n\n" ; sleep 1 ; km

echo -en "\n||||||||||     Starting network                 \n\n" ; sleep 1 ; dhclient eth0

echo -en "\n||||||||||     Choose location and time zone    \n\n" ; sleep 1 ; tz

echo -en "\n||||||||||     Assembling RAID array            \n\n" ; sleep 1 ; mdadm --assemble /dev/md2 /dev/sda2 /dev/sdb2 /dev/sdc2

echo -en "\n||||||||||     Unlocking encrypted target       \n\n" ; sleep 1 ; cryptsetup luksOpen /dev/md2 pv64SSDx3 ; vgchange -ay

echo -en "\n||||||||||     Creating target filesystems      \n\n" ; sleep 1 ; mkfs.vfat /dev/sda1 ; mkfs.ext4 /dev/mapper/vg64SSDx3-lvRoot

echo -en "\n||||||||||     Mounting Archboot packages       \n\n" ; sleep 1

mkdir -p "/packages/core-$(uname -m)"
mkdir -p "/packages/core-any"
modprobe loop
modprobe squashfs
mount -o ro,loop -t squashfs "/tmp/src/packages/archboot_packages_$(uname -m).squashfs" "/packages/core-$(uname -m)"
mount -o ro,loop -t squashfs "/tmp/src/packages/archboot_packages_any.squashfs"         "/packages/core-any"

echo -en "\n||||||||||     Configuring pacman for Archboot packages \n\n" ; sleep 1

cat > /tmp/pacman.conf << EOF
[options]

SigLevel = Never

Architecture = auto

CacheDir = /packages/core-$(uname -m)/pkg
CacheDir = /packages/core-any/pkg

[core]
Server = file:///packages/core-$(uname -m)/pkg
Server = http://mirror.its.dal.ca/archlinux/\$repo/os/\$arch

[extra]
Server = file:///packages/core-$(uname -m)/pkg
Server = http://mirror.its.dal.ca/archlinux/\$repo/os/\$arch

[community]
Server = http://mirror.its.dal.ca/archlinux/\$repo/os/\$arch

EOF

echo -en "\n||||||||||     Creating target directory structure    \n\n" ; sleep 1

mkdir -v /tmp/target
mount /dev/mapper/vg64SSDx3-lvRoot              /tmp/target
mkdir -v                                        /tmp/target/boot
mount -t vfat /dev/sda1                         /tmp/target/boot
mkdir -pv                                       /tmp/target/var/log
mkdir -pv                                       /tmp/target/var/lib/pacman
mkdir -pv                                       /tmp/target/var/cache/pacman/pkg
mkdir -v                                        /tmp/target/tmp
mkdir -pv                                       /tmp/target/media/myStuff
mount -t ext4 /dev/mapper/vg64SSDx3-lvMyStuff   /tmp/target/media/myStuff

echo -en "\n||||||||||     Updating target package database       \n\n" ; sleep 1

mkdir -m 755 -p /tmp/target/var/cache/pacman/pkg
mkdir -m 755 -p /tmp/target/var/lib/pacman
pacman --noconfirm --cachedir /var/cache/pacman/pkg --config /tmp/pacman.conf --root /tmp/target -Sy

echo -en "\n||||||||||     Installing base                         \n\n" ; sleep 1

pacman --noconfirm  --cachedir /var/cache/pacman/pkg --config /tmp/pacman.conf --root /tmp/target -Su base

echo -en "\n||||||||||     Installing systemd                      \n\n" ; sleep 1

pacman --noconfirm --cachedir /var/cache/pacman/pkg --config /tmp/pacman.conf --root /tmp/target -Rs sysvinit initscripts
pacman --noconfirm --cachedir /var/cache/pacman/pkg --config /tmp/pacman.conf --root /tmp/target -Su systemd{,-sysvcompat} systemd-arch-units

echo -en "\n||||||||||     Installing UEFI boot manager            \n\n" ; sleep 1

rm    -rf  /tmp/target/boot/grub
mkdir -pv  /tmp/target/boot/EFI/arch
pacman --noconfirm --cachedir /var/cache/pacman/pkg --config /tmp/pacman.conf --root /tmp/target -S efibootmgr

echo -en "\n||||||||||     Creating UEFI stub kernel relocate service \n\n" ; sleep 1
mkdir -p /tmp/target/boot/EFI/arch/
mkdir -p /tmp/target/opt/myArch/scripts/
#------------------------------------------------------------------------------
cat > /tmp/target/opt/myArch/scripts/UEFIstubMOVE.sh << EOF
#!/bin/bash
#
# /opt/myArch/scripts/UEFIstubMOVE.sh
#

mv /boot/vmlinuz-linux       /boot/EFI/arch/vmlinuz-linux.efi
mv /boot/initramfs-linux.img /boot/EFI/arch/

logger "Kernel \$(uname -r) was updated to \$(pacman --query linux | cut -c7-) on \$(date +%F) at \$(date +%X)"

EOF

#------------------------------------------------------------------------------
chmod +x /tmp/target/opt/myArch/scripts/UEFIstubMOVE.sh

#------------------------------------------------------------------------------
cat > /tmp/target/etc/systemd/system/UEFIstubMOVE.path << EOF
[Unit]
Description=Copy EFISTUB Kernel and Initramfs to UEFISYS Partition

[Path]
PathChanged=/boot/initramfs-linux-fallback.img
Unit=UEFIstubMOVE.service

[Install]
WantedBy=multi-user.target

EOF

#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
cat > /tmp/target/etc/systemd/system/UEFIstubMOVE.service << EOF
[Unit]
Description=Copy EFISTUB Kernel and Initramfs to UEFISYS Partition

[Service]
Type=oneshot
ExecStart=/opt/myArch/scripts/UEFIstubMOVE.sh

EOF

#------------------------------------------------------------------------------

#                                   #####################
echo -en "\n||||||||||     Creating system configurations \n\n" ; sleep 1
#                                   #####################

#                     ###############
cat > /tmp/target/tmp/mkinitcpio.conf << EOF
MODULES="nouveau dm_mod dm_crypt aes_x86_64 raid0"
HOOKS="base udev autodetect sata mdadm usbinput keymap encrypt lvm2 filesystems timestamp"

EOF

cp /tmp/.keymap        /tmp/target/tmp/
cp /tmp/.font          /tmp/target/tmp/
cp /tmp/.timezone      /tmp/target/tmp/
cp /tmp/.hardwareclock /tmp/target/tmp/

echo ${HOSTNAME} >     /tmp/target/tmp/hostname
cat >                  /tmp/target/tmp/hosts  << EOF
127.0.0.1   localhost.localdomain   localhost ${HOSTNAME}
::1         localhost.localdomain   localhost ${HOSTNAME}

EOF

#                     #####
cat > /tmp/target/tmp/fstab << EOF
#
# /etc/fstab: static file system information
#
# <file system>                   <dir>          <type> <options>        <dump> <pass>
tmpfs                             /tmp           tmpfs  nodev,nosuid     0      0
/dev/sda1                         /boot          vfat   defaults         0      0
/dev/mapper/vg64SSDx3-lvRoot    /              ext4   defaults,noatime 0      1
/dev/mapper/vg64SSDx3-lvMyStuff /media/myStuff ext4   defaults,noatime 0      0

EOF

#########################################################
#########################################################
#########################################################

echo -en "\n||||||||||     Creating chroot install script    \n\n" ; sleep 1

#-------------------------------------------------------------------------
cat > /tmp/target/install << EOF

echo -en "\n|||||||||||||||     Press [Enter] to configure your language \n\n" ; read ; nano /etc/locale.gen ; locale-gen

echo -en "\n|||||||||||||||     Press [Enter] to configure your mirrors \n\n" ; read ; nano /etc/pacman.d/mirrorlist

read KEY < /tmp/.keymap ; while [[ "\${KEY}" == *.* ]] ; do KEY=\${KEY%.*} ; done
echo -e "KEYMAP=\${KEY}" >  /etc/vconsole.conf
read FON < /tmp/.font   ; while [[ "\${FON}" == *.* ]] ; do FON=\${FON%.*} ; done
echo -e   "FONT=\${FON}" >> /etc/vconsole.conf
echo -en "\n|||||||||||||||     Console configured as: \n\n" ; cat /etc/vconsole.conf ;  echo -en "\n|||||||||||||||\n\n" ; sleep 1

cp /tmp/.timezone /etc/timezone
read TZONE < /etc/timezone
ln -s "/usr/share/zoneinfo/\${TZONE}" /etc/localtime
echo -en "\n|||||||||||||||     Timezone configured as: \n\n" ; cat /etc/timezone ;      echo -en "\n|||||||||||||||\n\n" ; sleep 1

cp /tmp/.hardwareclock   /etc/adjtime
echo -en "\n|||||||||||||||     Hardware clock configured as: \n\n" ; cat /etc/adjtime ; echo -en "\n|||||||||||||||\n\n" ; sleep 1

mdadm --examine --scan > /etc/mdadm.conf
echo -en "\n|||||||||||||||     RAID configured as:\n\n"  ; cat /etc/mdadm.conf ;        echo -en "\n|||||||||||||||\n\n" ; sleep 1

cp /tmp/hostname         /etc/
cp /tmp/hosts            /etc/
cp /tmp/fstab            /etc/


echo -en "\n|||||||||||||||     Remounting /boot                           \n\n" ; sleep 1 ; mount -t vfat /dev/sda1 /boot
cp /tmp/mkinitcpio.conf  /etc/
echo -en "\n|||||||||||||||     Creating kernel                            \n\n" ; sleep 1 ; mkinitcpio -p linux

echo -en "\n|||||||||||||||     Adding entries to UEFI boot loader         \n\n" ; sleep 1

modprobe efivars
modprobe dm-mod
echo "initrd=\\EFI\\arch\initramfs-linux.img \
     root=/dev/mapper/vg64SSDx3-lvRoot \
     cryptdevice=/dev/md2:vg64SSDx3 \
     add_efi_memmap pcie_aspm=force quiet" \
| \
iconv -f ascii -t ucs2 \
| \
efibootmgr \
     --create \
     --write-signature \
     --gpt \
     --disk /dev/sda \
     --part 1 \
     --label "${UEFI_LABEL} $(date +%F) $(date +%T)" \
     --loader '\\EFI\\arch\vmlinuz-linux.efi' \
     --append-binary-args -

echo "initrd=\\EFI\\arch\initramfs-linux.img \
     root=/dev/mapper/vg64SSDx3-lvRoot \
     cryptdevice=/dev/md2:vg64SSDx3 \
     add_efi_memmap pcie_aspm=force quiet" \
     > /boot/EFI/arch/linux.conf
efibootmgr \
     --create \
     --write-signature \
     --gpt \
     --disk /dev/sda \
     --part 1  \
     --label "${UEFI_LABEL} $(date +%F) $(date +%T) (CONF)" \
     --loader '\\EFI\\arch\vmlinuz-linux.efi'

echo -en "\n|||||||||||||||     Manually relocating UEFI stub kernel (systemd service will not be functional until reboot) \n\n" ; sleep 1

/opt/myArch/scripts/UEFIstubMOVE.sh

echo -en "\n|||||||||||||||     Enabling services                        \n\n" ; sleep 1

systemctl enable cronie.service
systemctl enable dhcpcd@.service
systemctl enable UEFIstubMOVE.path
systemctl start  UEFIstubMOVE.path

echo -en "\n|||||||||||||||     Configuring non-volatile journal         \n\n" ; sleep 1 ; mkdir /var/log/journal/

echo -en "\n|||||||||||||||     Enter a password for root                \n\n" ; sleep 1 ; passwd

echo -en "\n|||||||||||||||     Exiting chroot                           \n\n" ; sleep 1 ; exit

exit

EOF

#-------------------------------------------------------------------------
chmod a+x /tmp/target/install

echo -en "\n||||||||||     Chrooting into target                         \n\n" ; sleep 1

umount /tmp/target/boot
mount --bind /dev  /tmp/target/dev
mount --bind /sys  /tmp/target/sys
mount --bind /proc /tmp/target/proc
chroot /tmp/target /install

echo -en "\n||||||||||     You can remove boot entries you do not need with efibootmgr -b X -B (X=menu entry number) \n\n"
echo -en "\n||||||||||     and set the boot order with efibootmgr -o X,Y,Z (X,Y,Z=menu entry numbers)                \n\n"
echo -en "\n||||||||||     then reboot before you do anything else.
