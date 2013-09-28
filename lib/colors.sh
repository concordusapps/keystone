# Color utiltiy from:
# http://wiki.bash-hackers.org/snipplets/add_color_to_your_scripts

${ZSH_VERSION+false} || emulate ksh
${BASH_VERSION+shopt -s lastpipe extglob}

# colorSet [ --setaf | --setab | --misc ] var
# Assigns the selected set of escape mappings to the given associative array names.
function colors_init {
    typeset -a clrs msc
    typeset x
    clrs=(black red green orange blue magenta cyan grey darkgrey ltred ltgreen yellow ltblue ltmagenta ltcyan white)
    msc=(sgr0 bold dim smul blink rev invis)

    while ! ${2:+false}; do
        ${KSH_VERSION:+eval typeset -n "$2"=\$2}
        case ${1#--} in
            setaf|setab)
                for x in "${!clrs[@]}"; do
                    eval "$2"'[${clrs[x]}]=$(tput "${1#--}" "$x")'
                done
                ;;
            misc)
                for x in "${msc[@]}"; do
                    eval "$2"'[$x]=$(tput "$x")'
                done
                ;;
            *)
                return 1
        esac
        shift 2
    done
}

typeset -A fg bg style
colors_init --setaf fg --setab bg --misc style
