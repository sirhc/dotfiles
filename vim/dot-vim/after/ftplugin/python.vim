setlocal equalprg=autopep8\ -
setlocal keywordprg=pydoc

let b:interpreter = "python"

nmap <Leader>d :!pydoc "%:r"<CR>
