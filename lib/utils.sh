
# Ask for user input
# -----------------------------------------------------------------------------
_ask() {
    local value
    eval value=\$$3
    if [[ -z $value ]]; then
        # Prompt user for input.
        read -e -p "$1 ($2): " $3

        # Set to default if not given
        [[ -z $(eval echo "\$$3") ]] && export $3=$2

        # Export to the configuration file.
        eval value=\$$3
        echo "export $3=$value" >> $KEYSTONE_DIR/config.sh
    fi
}

##
# Ask a Y/N question
#------------------------------------------------------------------------------
function _yn {
    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question
        read -p "$1 [$prompt] " REPLY

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

# Echo and reset colors
# -----------------------------------------------------------------------------
_print() {
    echo -e "\E[1;37m$1"; tput sgr0
}

# Countdown
# -----------------------------------------------------------------------------
_countdown () {
    for i in `seq $1 -1 1`; do
    echo -en "\r$2 in $i seconds (ctrl-c to cancel and exit) <"
    for j in `seq 1 $i`; do echo -n "=="; done; echo -en "     \b\b\b\b\b"
    sleep 1; done; echo
}

# Check for network access
# -----------------------------------------------------------------------------
_check_network() {
    address=$(ip r | grep default | cut -d ' ' -f 3)
    if [ -z $address ]
    then
        return 1
    else
        ping -q -w 1 -c 1 $address > /dev/null
    fi
}

# Wait for network access
# -----------------------------------------------------------------------------
_wait_for_network() {
    while true
    do
        _check_network && return
        sleep 5
    done
}

# Load and execute a block
# -----------------------------------------------------------------------------
_load() {
    . "$KEYSTONE_DIR/blocks/$1.sh"
}

# Add an unofficial repository to pacman
# -----------------------------------------------------------------------------
_repo() {
    # Check if we have required this repository before.
    egrep -q "^\[$1\]" /etc/pacman.conf || \
        # Nope; add the repo to the pacman configuration.
        sed -i -e "/^\[core\]/r $KEYSTONE_DIR/lib/repo/$1" -e //N -e //N /etc/pacman.conf

    # Update repositories.
    pacman -Syy --noconfirm
}

# Install package from the offical repoistories
# -----------------------------------------------------------------------------
_install() {
    [ -f /var/lib/pacman/db.lck ] && rm /var/lib/pacman/db.lck
    if command -v powerpill >/dev/null 2>&1; then
        powerpill -Sy --noconfirm $@
    else
        pacman -Sy --noconfirm $@
    fi
}

# Remove package
# -----------------------------------------------------------------------------
_uninstall() {
    [ -f /var/lib/pacman/db.lck ] && rm /var/lib/pacman/db.lck
    pacman -Rnsc --noconfirm $@
}

# Install package from the AUR
# -----------------------------------------------------------------------------
_install_aur() {
    # Check to see if we can use the AUR helper.
    if command -v $KEYSTONE_AUR_HELPER >/dev/null 2>&1
    then
        # AUR helper is available.
        case $KEYSTONE_AUR_HELPER in
            aura) $KEYSTONE_AUR_HELPER -A --noconfirm "$@" ;;
            yaourt) $KEYSTONE_AUR_HELPER -S --noconfirm "$@" ;;
        esac

    else
        # AUR helper is not available; install the AUR helper.
        _load "aur/$KEYSTONE_AUR_HELPER"

        # Now use the AUR helper to install the package.
        _install_aur $@
    fi
}

# Install package from the AUR manually
# -----------------------------------------------------------------------------
# NOTE: This will FAIL if the AUR package depends on packages in the AUR that
#       are not installed.
_install_aur_manual() {
    local pkg=$1
    local build_dir=/tmp/build/$pkg
    mkdir -p $build_dir
    (
        cd $build_dir
        curl "https://aur.archlinux.org/packages/${pkg:0:2}/${pkg}/${pkg}.tar.gz" > ${pkg}.tar.gz
        tar -xzvf ${pkg}.tar.gz; cd ${pkg}
        makepkg --asroot -si --noconfirm;
    )
    rm -rf $build_dir
}
