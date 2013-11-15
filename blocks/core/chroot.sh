#!/usr/bin/env sh

# Set that we're in a chroot to the configuration.
echo "export KEYSTONE_CHROOT=1" >> ./config.sh

# Copy this repository to the new environment.
cp -r $(realpath $(dirname $0)) $KEYSTONE_MOUNT/root/

# Switch to new environment and run the install script.
arch-chroot $KEYSTONE_MOUNT "/root/keystone/install.sh"


# handle interactively assigned install drive value
echo -e "#!/bin/bash\nINSTALL_DRIVE=$INSTALL_DRIVE" > "${MNT}${POSTSCRIPT}";
grep -v "^\s*INSTALL_DRIVE.*" "${0}" >> "${MNT}${POSTSCRIPT}";
#cp "${0}" "${MNT}${POSTSCRIPT}";
chmod a+x "${MNT}${POSTSCRIPT}"; arch-chroot "${MNT}" "${POSTSCRIPT}";
