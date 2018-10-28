if executable("proselint") == 1
    let g:syntastic_markdown_checkers = ["proselint"]
endif

if executable("markdown") == 1
    let b:interpreter = "markdown"
endif

setlocal cinwords=
setlocal formatoptions+=n
setlocal keywordprg=dict

" The vim-markdown plugin sources html.vim, which sets the tab stops to 2. So
" reset them.
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=4
