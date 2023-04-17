" Return the Make target on the current line or the first one found directly
" above. If no targets are found above, we'll just behave like a bare `make`.
function! MakeTarget(...)
    for l:line in a:000
        let l:target = matchlist(l:line, '^\(\w\S*\):')
        if len(l:target) > 0
            return l:target[1]
        endif
    endfor
    return ''
endfunction

function! Make(...)
    let l:makeargs = a:000->join()

    " Special case for Makefiles, executing the target under the cursor.
    if &filetype == 'make' && len(l:makeargs) == 0
        let l:makeargs = MakeTarget(getline('.'), getline(search('^\w\S*:', 'bnW')))
    endif

    execute 'make ' . l:makeargs
endfunction

nnoremap <S-F5> :update<CR>:call Make()<CR>
