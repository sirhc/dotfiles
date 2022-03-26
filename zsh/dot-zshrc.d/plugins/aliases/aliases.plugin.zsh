# vim: ft=zsh nospell

alias bofh='ncat bofh.jeffballard.us 666 </dev/null | sed -ne "s/[^:]*: //p"'
alias curlk='curl -k'
alias ed='ed -p:'
alias emdash='echo "<—>"'
alias endash='echo "<–>"'
alias gitk='gitk --all &'
alias headers='curl -s -D- -o/dev/null'
alias igrep='grep -i'
alias indent="sed -e 's/^/    /'"
alias lh='ls -lh'
alias maze='perl -e "print qw(╱ ╲)[rand 2] while 1"'
alias now='date +%H:%M:%S'
alias p5addlib='eval "$( envmgr -p PERL5LIB lib )"'
alias p5clearenv='unset "$( env | grep ^PERL | cut -d= -f1 )"'
alias p5rmlib='eval "$( envmgr -r PERL5LIB lib )"'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias perlconf='perl -V:".*"'
alias pprove='prove -PPretty'
alias psusers='ps -Ao user= | SORT'
alias sumcolor='sed -e '"'"'s/\(^.*: \)\(OK\)$/\1\x1b[1;32m\2\x1b[0m/'"'"' -e '"'"'s/\(^.*: FAILED\)$/\x1b[1;37;41m\1\x1b[0m/'"'"''
alias tig='tig --all'
alias today='date +%Y-%m-%d'
alias tprove='prove --formatter TAP::Formatter::Elapsed'
alias vimf='vim +:NERDTreeToggle'
alias wgetk='wget --no-check-certificate'
alias wgeto='wget --content-disposition'
alias xclip='xclip -selection c'

if [[ ! -x /usr/bin/open ]]; then
    alias open=xdg-open
fi

if type thefuck >/dev/null 2>&1; then
    eval "$(thefuck --alias)"
fi

# http://dbocklandt.be/networking/ldapsearch-without-all-the-line-wrapping/
alias ldapunwrap='perl -p00e '"'"'s/\r?\n //g'"'"''

alias a2b="perl -E 'say sprintf q(%b), ord shift'"
alias a2d="perl -E 'say sprintf q(%d), ord shift'"
alias a2h="perl -E 'say sprintf q(%x), ord shift'"
alias a2o="perl -E 'say sprintf q(%o), ord shift'"
alias b2a="perl -E 'say sprintf q(%s), chr eval q(0b) . shift'"
alias b2d="perl -E 'say sprintf q(%d), eval q(0b) . shift'"
alias b2h="perl -E 'say sprintf q(%x), eval q(0b) . shift'"
alias b2o="perl -E 'say sprintf q(%o), eval q(0b) . shift'"
alias d2a="perl -E 'say sprintf q(%s), chr int shift'"
alias d2b="perl -E 'say sprintf q(%b), int shift'"
alias d2h="perl -E 'say sprintf q(%x), int shift'"
alias d2o="perl -E 'say sprintf q(%o), int shift'"
alias h2a="perl -E 'say sprintf q(%s), chr hex shift'"
alias h2b="perl -E 'say sprintf q(%b), hex shift'"
alias h2d="perl -E 'say sprintf q(%d), hex shift'"
alias h2o="perl -E 'say sprintf q(%o), hex shift'"
alias o2a="perl -E 'say sprintf q(%s), chr oct shift'"
alias o2b="perl -E 'say sprintf q(%b), oct shift'"
alias o2d="perl -E 'say sprintf q(%d), oct shift'"
alias o2h="perl -E 'say sprintf q(%x), oct shift'"

alias chr="perl -E 'say chr \$_ for @ARGV'"
alias ord="perl -E 'say ord \$_ for @ARGV'"

# https://twitter.com/climagic/status/507611283818942465
alias what_are_those_damn_conditional_expressions="man bash | sed -n '/^CONDITIONAL EXPRESSIONS/,/^SIMPLE COMMAND/p'"

alias envi='env -i'
alias envp='env -i PATH=/bin:/usr/bin'
alias envlp='env -i PATH=/bin:/usr/bin:/usr/local/bin'
alias envpl='env -i PATH=~/.plenv/bin:~/.plenv/shims:/bin:/usr/bin PLENV_SHELL=bash PLENV_ROOT=~/.plenv'

alias typemap='perl -MConfig -le '"'"'print "$Config{installprivlib}/ExtUtils/typemap"'"'"''
alias xsubcpp='cpp -I`perl -MConfig -le '"'"'print "$Config{archlib}/CORE"'"'"'`'

# https://twitter.com/dmarti/status/1295365357146791936
alias 2020date='echo March $((($(date +%s)-$(date +%s --date "2020-02-29"))/86400))\, 2020'

# Terraform aliases.
alias tf='terraform'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tff='terraform fmt'
alias tfi='terraform init'
alias tfo='terraform output'
alias tfp='terraform plan'
alias tfv='terraform validate'
