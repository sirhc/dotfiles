"============================================================================
"File:        checkov.vim
"Description: Checkov configuration for syntastic
"Maintainer:  Chris Grau
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================

if exists('g:loaded_syntastic_cloudformation_checkov_checker')
    finish
endif
let g:loaded_syntastic_cloudformation_checkov_checker = 1

let s:save_cpo = &cpo
set cpo&vim

" Taken from autoload/syntastic/preprocess.vim
function! s:_decode_JSON(json) abort
    if a:json ==# ''
        return []
    endif

    if substitute(a:json, '\v\"%(\\.|[^"\\])*\"|true|false|null|[+-]?\d+%(\.\d+%([Ee][+-]?\d+)?)?', '', 'g') !~# "[^,:{}[\\] \t]"
        " JSON artifacts
        let true = 1
        let false = 0
        let null = ''

        try
            let object = eval(a:json)
        catch
            " malformed JSON
            let object = ''
        endtry
    else
        let object = ''
    endif

    return object
endfunction

function! SyntaxCheckers_cloudformation_checkov_Preprocess(errors) abort
    let errs = s:_decode_JSON(join(a:errors, ''))

    " Convert the JSON structure returned by checkov to something that looks like,
    "
    "     filename:line_number:type: logical_resource_id: message [id]

    let out = []
    if type(errs) == type([])
        for e in errs
            for v in e['file_results']['violations']
                for i in range(len(v['logical_resource_ids']))
                    let msg =
                        \ e['filename'] . ':' .
                        \ v['line_numbers'][i] . ':' .
                        \ (v['type'] == 'WARN' ? 'w' : 'e') . ': ' .
                        \ v['logical_resource_ids'][i] . ': ' .
                        \ v['message'] . ' ' .
                        \ '[' . v['id'] . ']'

                    call add(out, msg)
                endfor
            endfor
        endfor
    else
        call syntastic#log#warn('checker cloudformation/checkov: unrecognized error format (crashed checker?)')
    endif

    return out
endfunction

function! SyntaxCheckers_cloudformation_checkov_GetLocList() dict
    let makeprg = self.makeprgBuild({
        \ 'args_after': '-o json',
        \ 'fname_before': '-f' })

    " Check: CKV_AWS_65: "Ensure container insights are enabled on ECS cluster"
    " \tFAILED for resource: AWS::ECS::Cluster.Cluster
    " \tFile: customer.template:396-419
    "let errorformat = '%f:%l:%t: %m'
    "let errorformat =
    "    \ '%ECheck: %t: "%m",' .
    "    \ '%C\tFAILED %.%#,' .
    "    \ '%Z\tFile: %f:%l'
    let errorformat =
        \ '%E\tFile: %f:%l'

    let loclist = SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat })
        "\ 'Preprocess': 'SyntaxCheckers_cloudformation_checkov_Preprocess' })

    echom loclist
    return loclist
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'cloudformation',
    \ 'name': 'checkov',
    \ 'exec': 'checkov' })

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:
