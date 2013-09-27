
ask() {
    read -e -p "$1" $3
    [ -z $(eval \$$3) ] && export $3=$2
}

print() {
    echo -e "$1" ${style[sgr0]}
}

check_network() {
    address=$(ip r | grep default | cut -d ' ' -f 3)
    if [ -z $address ]
    then
        return 1
    else
        ping -q -w 1 -c 1 $address > /dev/null
    fi
}

wait_for_network() {
    while true
    do
        check_network && return
        sleep 5
    done
}

load() {
    ./blocks/$1*
}
