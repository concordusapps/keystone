ask() {
    read -e -p "$1" $3
    [ -z $(eval \$$3) ] && export $3=$2
}
