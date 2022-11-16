#compdef awsvpn-cli

local ret=1

_arguments -C -A '-*' : \
    '(-c --connect -C --force-connect -d --disconnect)'{-c+,--connect=}'[connect to a profile, if not connected]:profile:->profile' \
    '(-c --connect -C --force-connect -d --disconnect)'{-C+,--force-connect=}'[connect to a profile, disconnecting if necessary]:profile:->profile' \
    '(-d --disconnect)'{-d,--disconnect}'[disconnect from a profile]' \
    '(-p --profiles)'{-p,--profiles}'[display the configured profiles]' \
    '(-s --show)'{-s,--show}'[show the currently connected profile]' \
    '(-h --help)'{-h,--help}'[print usage]' \
    '(-v --verbose)'{-v,--verbose}'[print the actions being taken]' && ret=0

case $state in
    (profile)
        local -a profiles=("${(f)"$( awsvpn-cli --profiles )"}")
        compadd - "${profiles[@]}"
        ;;
esac

return ret
