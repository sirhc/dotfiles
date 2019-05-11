setlocal equalprg=autopep8\ -
setlocal keywordprg=pydoc

nmap <Leader>d :!pydoc "%:r"<CR>
