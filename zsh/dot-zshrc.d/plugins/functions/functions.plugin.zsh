# Create a 1280x720 color plasma image. Different each time.
bg:plasma() {
    convert -size 1280x720 plasma:green-blue background.png
}

cd() {
    if [[ -z $2 ]]; then
        if [[ -f $1 ]]; then
            builtin cd $1:h && ls
        else
            builtin cd $1 && ls
        fi
    else
        builtin cd $* && ls
    fi
}

compreload() {
    local fn=$1

    if [[ ! $fn =~ '^_' ]]; then
        fn="_${fn}"
    fi

    unfunction $fn
    autoload -U $fn
}

diffdirs() {
    diff -rq -x .git "$1" "$2" | sort
}

dudirs() {
    find . -type d -mindepth 1 -maxdepth 1 -print0 | xargs -0 du -hs | sort -hr
}

envappend() {
    eval "$(envmgr -a "$@")"
}

envprefix() {
    eval "$(envmgr -p "$@")"
}

envrm() {
    eval "$(envmgr -r "$@")"
}

# > diff -ruNq ...
# Files file1 and file2 differ
Files() {
    vimdiff "$1" "$3"
}

flip() {
    if [[ $(roll 1d2) = 1 ]]; then
        echo heads
    else
        echo tails
    fi
}

# https://sysadvent.blogspot.com/2017/12/day-18-awesome-command-line-fuzzy.html
fshow() {
    git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" \
        | fzf --ansi \
              --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs -I % sh -c 'git show --color=always %'" \
              --bind "enter:execute:
                      (grep -o '[a-f0-9]\{7\}' | head -1 |
                      xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                      {}
FZF-EOF"
}

# https://twitter.com/climagic/status/416618976496463872
funfact() {
    elinks -dump randomfunfacts.com | sed -n -e '/^| /p' | sed -e 's/^| //' -e 's/ *|$//'
}

git-top() {
    builtin cd "$(git root)" && pwd && ls
}

# http://blogs.perl.org/users/aristotle/2015/12/locallib-ez.html
perl-lib() {
    eval "$(perl -M'local::lib @ARGV' - "$@" 0<&-)"
}

#mkcd() {
#    mkdir "$1" && builtin cd "$1" && pwd
#}

myip() {
    curl -s http://ifconfig.io/ip
    printf '\n'
}

proveall() {
    if [[ -d blib ]]; then
        prove -j9 --state=slow,save -br t
    else
        prove -j9 --state=slow,save -lr t
    fi
}

qbc() {
    echo "scale=${2:-2}; $1" | bc -l
}

enmorse() {
    perl -MConvert::Morse=as_morse -E 'say as_morse($_) while <>'
}

demorse() {
    perl -MConvert::Morse=as_ascii -E 'say as_ascii($_) while <>'
}

setenv() {
    export "$1"="$2"
}

slang() {
    elinks -no-references -no-numbering -dump "http://www.urbandictionary.com/define.php?term=$1" | sed -n '/1\. /,/2\./p'
}

splitpath() {
    # TODO: Is there a Zsh way to do this?
    eval "echo \$$1" | tr ':' '\n'
}

utime() {
    perl -le "print scalar localtime '$1'"
}

# Re-exec the shell to pick up configuration changes.
reload() {
    if [[ -n $(jobs) ]]; then
        print "${ZSH_NAME}: you have suspended jobs."
        return 0
    fi

    exec -l ${SHELL:t}
}

rlog() {
    command rlog "$@" |& ${=PAGER:-less -r}
}

roll() {
    local i

    for i in "$@"; do
        perl -MGames::Dice=roll -E "say roll '$i'"
    done
}

# Draw a horizontal rule in the terminal.
# https://twitter.com/climagic/status/512254743985799168
separator() {
    printf '%*s\n' "$(tput cols)" '' | tr ' ' -
}

stardate() {
    perl -MAcme::Stardate -E 'say stardate()'
}

# http://www.perladvent.org/2012/2012-12-20.html
t() {
    prove -PPretty "$@"
}

timeshell() {
    print "Timing startup of $SHELL..."
    for i in {0..10}; do
        time $SHELL -i -c exit
    done
}

tmpl() {
    local file
    file="$(mktemp --suffix=.pl --tmpdir XXXXXXXXXX)"
    {
        printf '#!%s\n' "$( which perl )"
        printf 'use strict;\n'
        printf 'use warnings;\n'
    } >"$file"
    "${EDITOR:-vim}" "$file"
}

# take functions (from oh-my-zsh)

# mkcd is equivalent to takedir
function mkcd takedir() {
    mkdir -p $@ && cd ${@:$#}
}

function takeurl() {
    local data thedir
    data="$(mktemp)"
    curl -L "$1" > "$data"
    tar xf "$data"
    thedir="$(tar tf "$data" | head -n 1)"
    rm "$data"
    cd "$thedir"
}

function takegit() {
    git clone "$1"
    cd "$(basename ${1%%.git})"
}

function take() {
    if [[ $1 =~ ^(https?|ftp).*\.tar\.(gz|bz2|xz)$ ]]; then
        takeurl "$1"
    elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
        takegit "$1"
    else
        takedir "$@"
    fi
}

# take functions

topcount() {
    sort | uniq -c | sort -rn | head -n "${1:-10}"
}

vimless() {
    vim -u \$VIMRUNTIME/macros/less.vim "${@:--}"
}

weather() {
    curl -s "http://wttr.in/${*// /+}"
}

# Silly command based on the Infocom wait/z instruction. This has since been
# replaced by <~/.oh-my-zsh/plugins/z>.
# z() {
#     printf 'Time passes.\n\n'
# }

# http://sysadvent.blogspot.com/2011/12/day-9-data-in-shell.html

# _awk_col() {
#     echo "$1" | egrep -v '^[0-9]+$' || echo "\$$1"
# }

# sum() {
#     [[ "${1#-F}" != "$1" ]] && SP=${1} && shift
#     [[ "$#" -eq 0 ]] && set -- 0
#     key="$(_awk_col "$1")"
#     awk $SP "{ x+=$key } END { printf(\"%d\n\", x) }"
# }

# sumby() {
#     [[ "${1#-F}" != "$1" ]] && SP=${1} && shift
#     [[ "$#" -lt 0 ]] && set -- 0 1
#     key="$(_awk_col "$1")"
#     val="$(_awk_col "$2")"
#     awk $SP "{ a[$key] += $val } END { for (i in a) { printf(\"%d %s\\n\", a[i], i) } }"
# }

# countby() {
#     [[ "${1#-F}" != "$1" ]] && SP=${1} && shift
#     [[ "$#" -eq 0 ]] && set -- 0
#     key="$(_awk_col "$1")"
#     awk $SP "{ a[$key]++ } END { for (i in a) { printf(\"%d %s\\n\", a[i], i) } }"
# }

# Functional stuff.
# http://yannesposito.com/Scratch/en/blog/Higher-order-function-in-zsh/index.html

# Usage: map fn a b c d
map() {
    local fn="$1"
    local i=
    shift

    for i in "$@"; do
        $fn "$i"
    done
}

# Usage: x count command
#x() {
#    local count="$1"
#    local i
#    shift
#
#    for i in $(seq "$count"); do
#        "$@"
#    done
#}

# https://twitter.com/climagic/status/367676137310150656
# Usage: blue "I'm blue"
blue() {
    tput setaf 4
    echo "$@"
    tput sgr0
}

# "List" grep, similar to Perl's grep builtin.
lgrep () {
    local r="$1"; shift
    local i

    for i in "$@"; do
        if [[ "$i" =~ $r ]]; then
            echo -n "$i "
        fi
    done
    echo
}