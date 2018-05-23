if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    au!

    au BufNewFile,BufRead *.adoc      setf asciidoc
    au BufNewFile,BufRead *.ifm       setf ifm
    au BufNewFile,BufRead *.mail      setf mail
    au BufNewFile,BufRead *.p6        setf perl6
    au BufNewFile,BufRead *.pde       setf arduino
    au BufNewFile,BufRead *.zsh-theme setf zsh

    au BufNewFile,BufRead *.tsv       setf tsv

    au BufNewFile,BufRead *.puml      setf plantuml
augroup END
