let g:syntastic_markdown_checkers = ["proselint"]
let b:interpreter = "markdown"

setlocal cinwords=
setlocal formatoptions+=n
setlocal keywordprg=dict

" The vim-markdown plugin sources html.vim, which sets the tab stops to 2. So
" reset them.
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=4
