setlocal complete+=k
setlocal nowrap
setlocal shiftwidth=2
setlocal softtabstop=2

nnoremap <silent> <leader>uu :call vimwiki#base#linkify()<cr>

" VimWiki uses <Tab> to navigate tables and loads after Copilot.
inoremap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
