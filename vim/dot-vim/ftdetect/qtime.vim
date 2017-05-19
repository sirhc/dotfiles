function! s:DetectQtime()
    if strpart(getline(1), 0, 23) == "#!/usr2/cgrau/bin/qtime"
        setfiletype qtime
    endif
endfunction

autocmd BufNewFile,BufRead * call s:DetectQtime()
