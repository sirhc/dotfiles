setlocal conceallevel=0
setlocal foldlevel=99
setlocal foldmethod=syntax
setlocal formatprg=jq\ .

let b:ale_linters = ['jq']
