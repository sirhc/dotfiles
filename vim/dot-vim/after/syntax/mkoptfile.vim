" Vim syntax file
" Language:     mkoptfile
" Maintainer:   Chris Grau <cgrau@qualcomm.com>
" Filenames:    *.opt.in
" Last Change:  2015 Nov 02

if exists("b:current_syntax")
    finish
endif

runtime! syntax/tt2.vim
unlet! b:current_syntax

let b:current_syntax = "mkoptfile"
