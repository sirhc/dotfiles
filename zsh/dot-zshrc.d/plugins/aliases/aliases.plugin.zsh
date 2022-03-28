alias ed='ed -p:'
alias wget='wget --content-disposition'
alias xclip='xclip -selection c'

alias emdash='echo "<—>"'
alias endash='echo "<–>"'
alias headers='curl -s -D- -o/dev/null'
alias lh='ls -lh'
alias now='date +%H:%M:%S'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias tiga='tig --all'
alias today='date +%Y-%m-%d'

alias p5addlib='eval "$( envmgr -p PERL5LIB lib )"'
alias p5clearenv='unset "$( env | grep ^PERL | cut -d= -f1 )"'
alias p5rmlib='eval "$( envmgr -r PERL5LIB lib )"'
alias perlconf='perl -V:".*"'
alias pprove='prove -PPretty'
alias tprove='prove --formatter TAP::Formatter::Elapsed'
alias typemap='perl -MConfig -le '"'"'print "$Config{installprivlib}/ExtUtils/typemap"'"'"''
alias xsubcpp='cpp -I`perl -MConfig -le '"'"'print "$Config{archlib}/CORE"'"'"'`'

alias bofh='ncat bofh.jeffballard.us 666 </dev/null | sed -ne "s/[^:]*: //p"'
alias maze='perl -e "print qw(╱ ╲)[rand 2] while 1"'

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

# https://twitter.com/dmarti/status/1295365357146791936
alias 2020date='echo March $((($(date +%s)-$(date +%s --date "2020-02-29"))/86400))\, 2020'

alias date-locale='date +%c'
alias isodate='date +%Y-%m-%dT%H:%M:%S%z'
alias isodate-basic='date -u +%Y%m%dT%H%M%SZ'
alias isodate-utc='date -u +%Y-%m-%dT%H:%M:%SZ'
alias unixstamp='date +%s'
