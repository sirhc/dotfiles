" Vim syntax file
" Language:     QTime
" Maintainer:   Chris Grau <cgrau@qualcomm.com>
" Last Change:  Nov 02, 2015
" Version:      1
" URL:          https://github.qualcomm.com/cgrau/

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

syn match   qtimeComment    "^\s*\zs#.*$"
syn match   qtimeDay        "^\(Mon\|Tues\|Wednes\|Thurs\|Fri\|Satur\|Sun\)day:"
syn match   qtimeCode       "^[0-9]\+\>"
syn match   qtimeTime       "\<\d\d\d\d-"
syn match   qtimeTime       "\<\d\d\d\d-\d\d\d\d\>"
syn match   qtimeDesc       "\%21c.*"

hi def link qtimeComment    Comment
hi def link qtimeDay        Keyword
hi def link qtimeCode       Identifier
hi def link qtimeTime       Number
hi def link qtimeDesc       Comment

let b:current_syntax = "qtime"
