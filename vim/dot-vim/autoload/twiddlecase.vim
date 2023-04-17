" http://vim.wikia.com/wiki/Switching_case_of_characters
"
" With the following, you can visually select text then press ~ to convert the
" text to UPPER CASE, then to lower case, then to Title Case. Keep pressing ~
" until you get the case you want.

function! twiddlecase#TwiddleCase(str)
    if a:str ==# toupper(a:str)
        let l:result = tolower(a:str)
    elseif a:str ==# tolower(a:str)
        let l:result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
    else
        let l:result = toupper(a:str)
    endif

    return l:result
endfunction
