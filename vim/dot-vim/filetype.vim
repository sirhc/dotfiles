if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    au!

    au BufNewFile,BufRead *.ifm  setf ifm
    au BufNewFile,BufRead *.mail setf mail
    au BufNewFile,BufRead *.p6   setf perl6
    au BufNewFile,BufRead *.pde  setf arduino
augroup END
