
# Ask for user input
# -----------------------------------------------------------------------------
_ask() {
    read -e -p "$1" $3
    [ -z $(eval \$$3) ] && export $3=$2
}

# Echo and reset colors
# -----------------------------------------------------------------------------
_print() {
    echo -e ${fg[white]}${style[bold]} "$1" ${style[sgr0]}
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
    . "./blocks/$1.sh"
}

# Add an unofficial repository to pacman
# -----------------------------------------------------------------------------
_repo() {
    # Check if we have required this repository before.
    egrep -q "^\[$1\]" /etc/pacman.conf || \
        # Nope; add the repo to the pacman configuration.
        sed -i -e "/^\[core\]/r ./lib/repo/$1" -e //N -e //N /etc/pacman.conf
}

# Install package from the offical repoistories
# -----------------------------------------------------------------------------
_install() {
    pacman -Sy --noconfirm $@
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
        local pkg=$KEYSTONE_AUR_HELPER
        local build_dir=/tmp/build/$pkg
        mkdir -p $build_dir
        (
            cd $build_dir
            wget "https://aur.archlinux.org/packages/${pkg:0:2}/${pkg}/${pkg}.tar.gz"
            tar -xzvf ${pkg}.tar.gz; cd ${pkg}
            makepkg --asroot -si --noconfirm;
        )
        rm -rf $build_dir

        # Now use the AUR helper to install the package.
        _install_aur $@
    fi
}
