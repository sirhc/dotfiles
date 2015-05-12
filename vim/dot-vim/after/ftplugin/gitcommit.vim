setlocal completefunc=GitCommitComplete
setlocal spell
setlocal textwidth=72

function! GitCommitComplete(findstart, base)
    if a:findstart
        " Locate the start of the word.
        let l:line  = getline('.')
        let l:start = col('.') - 1

        while start > 0 && line[start - 1] =~ '\S'
            let l:start -= 1
        endwhile

        return l:start
    endif

    " Complete user names.
    if strpart(a:base, 0, 1) == '@'
        let l:prefix = strpart(a:base, 1)
        let l:result = []
        let l:output = systemlist('getent passwd | cut -d: -f1,5 | sort')

        if v:shell_error
            echoerr l:output[0]
            return -1
        endif

        for l:line in l:output
            let l:pos  = stridx(l:line, ':', 0)
            let l:user = strpart(l:line, 0, l:pos)
            let l:name = strpart(l:line, l:pos + 1)

            if stridx(l:line, l:prefix) == 0
                call add(l:result, { 'word': '@' . l:user, 'menu': l:name })
            endif
        endfor

        return l:result
    endif

    " Complete GitHub issues.
    if strpart(a:base, 0, 1) == '#'
        let l:prefix = strpart(a:base, 1)
        let l:result = []
        let l:output = systemlist('hub issue | sort -n')

        if v:shell_error
            echoerr l:output[0]
            return -1
        endif

        for l:line in l:output
            let l:pos1 = match(l:line, '\d', 0)
            let l:pos2 = stridx(l:line, ']', 0)

            let l:issue       = strpart(l:line, l:pos1, l:pos2 - l:pos1)
            let l:description = strpart(l:line, l:pos2 + 2)

            if stridx(l:issue, l:prefix) == 0
                call add(l:result, { 'word': '#' . l:issue, 'menu': l:description })
            endif
        endfor

        return l:result
    endif

    return []
endfunction
