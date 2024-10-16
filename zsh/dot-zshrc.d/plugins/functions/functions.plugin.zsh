# Keep the functions that override existing commands near the top, so I don't
# lose track of them.

function \$() {
    local cmd=("$@")
    local r

    print -- "Do you want to run this command? ${cmd[*]}"
    read 'r?[y/N] '
    if [[ ${r:l} =~ '^y(es)?$' ]]; then
        "${cmd[@]}"
    else
        return 2
    fi
}

function \=() {
    print $(( ${@//,} ))
}

# > sd https://github.com/<user>/<repo>/pull/<num> -> cd ~/src/github.com/<user>/<repo>
function sd {
    local dir="${HOME}/src/${1#*://}"

    # Even if the directory from the argument doesn't exist, eventually we'll drop back to $HOME and the while loop will
    # break.
    while true; do
        if [[ -d $dir ]]; then
            cd "$dir"
            break
        fi
        dir="${dir:h}"
    done
}

function exercism {
    local output

    # > exercism download --exercise=bob --track=jq
    #                         -> stderr
    # Downloaded to           -> stderr
    # <home>/exercism/jq/bob  -> stdout
    { output="$( command exercism "$@" | tee /dev/fd/3 )"; } 3>&1

    if [[ $1 = download ]]; then
        print

        if [[ ! -d "$output" ]]; then
            print "$0: $output: not found" 1>&2
            return 1
        fi

        if [[ $( git -C "${output}" -P log --oneline . | wc -l ) -gt 0 ]]; then
            print "$0: ${output}: already committed to git"
            return
        fi

        # Welcome to Hello World on Exercism's Vim script Track.
        git -C "$output" add .
        git -C "$output" commit -m "Download $( sed -n -e '/^Welcome to /{s/^Welcome to //; s/\.$//; p}' "$output/README.md" | head -1 )"

        return
    fi

    if [[ $1 = submit ]]; then
        print

        if [[ ! -f README.md ]]; then
            print "$0: README.md not found" 1>&2
            return 1
        fi

        git commit -am "Submit solution for $( sed -n -e '/^Welcome to /{s/^Welcome to //; s/\.$//; p}' README.md | head -1 )"

        return
    fi
}

function rlog {
    command rlog "$@" |& ${=PAGER:-less -r}
}

function md5sum sha1sum sha224sum sha256sum sha384sum sha512sum {
    command $0 "$@" |& sed -e 's/\(^.*: \)\(OK\)$/\1\x1b[1;32m\2\x1b[0m/' -e 's/\(^.*: FAILED\)$/\x1b[1;37;41m\1\x1b[0m/'
}

# Create a 1280x720 color plasma image. Different each time.
# TODO: Add option for size.
bg:plasma() {
    convert -size 1280x720 plasma:"${1:-green}-${2:-blue}" PNG:- | display -
}

function diffdirs {
    diff -rq -x .git "$1" "$2" | sort
}

function envappend {
    eval "$(envmgr -a "$@")"
}

function envprefix {
    eval "$(envmgr -p "$@")"
}

function envrm {
    eval "$(envmgr -r "$@")"
}

# > diff -ruNq ...
# Files file1 and file2 differ
function Files {
    vimdiff "$1" "$3"
}

function flip {
    if (( $(roll 1d2) == 1 )); then
        print heads
    else
        print tails
    fi
}

# https://sysadvent.blogspot.com/2017/12/day-18-awesome-command-line-fuzzy.html
function fshow {
    # TODO: Check for git repo
    # TODO: Make sure fzf is installed
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
function funfact {
    elinks -dump randomfunfacts.com | sed -n -e '/^| /p' | sed -e 's/^| //' -e 's/ *|$//'
}

function git-top {
    builtin cd "$(git root)" && pwd && ls
}

# http://blogs.perl.org/users/aristotle/2015/12/locallib-ez.html
function perl-lib {
    eval "$(perl -M'local::lib @ARGV' - "$@" 0<&-)"
}

function mr {
    if [[ -n "${MR_CONFIG:-}" ]]; then
        command mr --config "$MR_CONFIG" "$@"
    else
        command mr "$@"
    fi
}

function myip {
    # TODO: This only does IPv6?
    print "$(curl -s http://ifconfig.io/ip)"
}

function qbc {
    echo "scale=${2:-2}; $1" | bc -l
}

function quote {
    setopt localoptions nopromptsubst

    local data
    data="$(command curl -s --connect-timeout 2 http://www.quotationspage.com/random.php |
        command iconv -c -f ISO-8859-1 -t UTF-8 |
        command grep -a -m 1 'dt class="quote"')"

    [[ -n $data ]] || return 1

    local quote author
    quote=$(sed -e 's|</dt>.*||g' -e 's|.*html||g' -e 's|^[^a-zA-Z]*||' -e 's|</a..*$||g' <<< "$data")
    author=$(sed -e 's|.*/quotes/||g' -e 's|<.*||g' -e 's|.*">||g' <<< "$data")

    print -P "%F{5}${quote}%f"
    print -P "%F{3}${author}%f"
}

function enmorse {
    perl -MConvert::Morse=as_morse -E 'say as_morse($_) while <>'
}

function demorse {
    perl -MConvert::Morse=as_ascii -E 'say as_ascii($_) while <>'
}

function setenv {
    export "$1"="$2"
}

function slang {
    elinks -no-references -no-numbering -dump "http://www.urbandictionary.com/define.php?term=$1" | sed -n '/1\. /,/2\./p'
}

# Re-exec the shell to pick up configuration changes.
function reload {
    if [[ -n $(jobs) ]]; then
        print "${ZSH_NAME}: you have suspended jobs."
        return 0
    fi

    exec -l ${SHELL:t}
}

# E.g., `roll 2d6`
function roll {
    local _roll="${1:?missing die spec}"

    if [[ $_roll =~ '^d[0-9]+$' ]]; then
        _roll="1$_roll"
    fi

    if [[ ! $_roll =~ '^[0-9]+d[0-9]+$' ]]; then
        print "$0: invalid die spec: $_roll"
    fi

    local _count="${_roll%d*}"
    local _sides="${_roll#*d}"

    _roll=0
    while (( _count > 0 )); do
        _roll=$(( _roll + (RANDOM % _sides + 1) ))
        _count=$(( _count - 1 ))
    done
    print $_roll
}

# Draw a horizontal rule in the terminal.
# https://twitter.com/climagic/status/512254743985799168
function separator {
    printf '%*s\n' "$(tput cols)" '' | tr ' ' -
}

function stardate {
    perl -MAcme::Stardate -E 'say stardate()'
}

function timeshell {
    print "Timing startup of $SHELL..."
    for i in {0..10}; do
        time $SHELL -i -c exit
    done
}

function tmpl {
    local file
    file="$(mktemp --suffix=.pl --tmpdir XXXXXXXXXX)"
    {
        printf '#!%s\n' "$( which perl )"
        printf 'use strict;\n'
        printf 'use warnings;\n'
    } >"$file"
    "${EDITOR:-vi}" "$file"
}

# Some handy `take` functions, <https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/functions.zsh>.

function mkcd takedir {
    mkdir -p $@ && cd ${@:$#}
}

function takeurl {
    local data thedir
    data="$(mktemp)"
    curl -L "$1" > "$data"
    tar xf "$data"
    thedir="$(tar tf "$data" | head -n 1)"
    rm "$data"
    cd "$thedir"
}

function takegit {
    git clone "$1"
    cd "$(basename ${1%%.git})"
}

function take {
    if [[ $1 =~ ^(https?|ftp).*\.tar\.(gz|bz2|xz)$ ]]; then
        takeurl "$1"
    elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
        takegit "$1"
    else
        takedir "$@"
    fi
}

function topcount {
    sort | uniq -c | sort -rn | head -n "${1:-10}"
}

function vimless {
    vim -u \$VIMRUNTIME/macros/less.vim "${@:--}"
}

function weather {
    curl -s "http://wttr.in/${*// /+}"
}

# Silly command based on the Infocom wait/z instruction. This has since been
# replaced by the [z plugin](https://github.com/rupa/z.git).
# function z {
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

# Functional stuff <http://yannesposito.com/Scratch/en/blog/Higher-order-function-in-zsh/index.html>.

function map {
    local fn="${1:?usage: map fn a b c d...}" i
    shift

    for i in "$@"; do
        $fn "$i"
    done
}

# Usage: x <count> <command>
function x {
    local _count="${1:?usage: x <count> <command>}" _i
    shift

    for _i in {1..$_count}; do
        "$@"
    done
}

# https://twitter.com/climagic/status/367676137310150656
# Usage: blue "I'm blue"
function blue {
    tput setaf 4
    echo "$@"
    tput sgr0
}

# "List" grep, similar to Perl's grep builtin.
function lgrep {
    local r="$1"; shift
    local i

    for i in "$@"; do
        if [[ "$i" =~ $r ]]; then
            echo -n "$i "
        fi
    done
    echo
}
