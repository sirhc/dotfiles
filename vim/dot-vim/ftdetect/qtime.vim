function! s:DetectQtime()
    if getline(1) =~ '^#!.*qtime'
        setfiletype qtime
    endif
endfunction

autocmd BufNewFile,BufRead * call s:DetectQtime()
