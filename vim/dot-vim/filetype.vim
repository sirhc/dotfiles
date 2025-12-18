if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    au!
    au BufNewFile,BufRead *.adoc       setf asciidoc
    au BufNewFile,BufRead *.cheat      setf navi
    au BufNewFile,BufRead *.drl        setf drools
    au BufNewFile,BufRead *.ifm        setf ifm
    au BufNewFile,BufRead *.mail       setf mail
    au BufNewFile,BufRead *.p6         setf perl6
    au BufNewFile,BufRead *.pde        setf arduino
    au BufNewFile,BufRead *.prr        setf prr
    au BufNewFile,BufRead *.puml       setf plantuml
    au BufNewFile,BufRead *.risor      setf risor
    au BufNewFile,BufRead *.tsv        setf tsv
    au BufNewFile,BufRead *.zsh-theme  setf zsh
    au BufNewFile,BufRead .mrconfig*   setf toml
    au BufNewFile,BufRead Jenkinsfile* setf groovy
    au BufNewFile,BufRead known_hosts  setf known_hosts

    au BufNewFile,BufRead git-create-pull-request.* setf gitconfig

    au BufNewFile,BufRead *.container,*.network,*.volume,*.kube setf systemd
augroup END
