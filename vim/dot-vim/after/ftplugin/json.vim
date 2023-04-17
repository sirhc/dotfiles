setlocal conceallevel=0
setlocal equalprg=jq\ .
setlocal foldlevel=99
setlocal foldlevelstart=99
setlocal foldmethod=syntax
setlocal formatprg=jq\ .
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2

let b:ale_linters = ['jq']
