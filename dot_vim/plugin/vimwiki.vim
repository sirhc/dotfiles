let g:vimwiki_list = [{
  \ 'auto_tags':                 1,
  \ 'automatic_nested_syntaxes': 1,
  \ 'diary_frequency':           'weekly',
  \ 'list_margin':               0,
  \ 'maxhi':                     1,
  \ 'path':                      '~/Documents/VimWiki/',
  \}]

let g:vimwiki_auto_chdir    = 1
let g:vimwiki_global_ext    = 0
let g:vimwiki_hl_cb_checked = 2
let g:vimwiki_hl_headers    = 1

let g:taskwiki_data_location         = '~/.local/share/task/'
let g:taskwiki_disable_concealcursor = 1
let g:taskwiki_dont_fold             = 1
let g:taskwiki_dont_preserve_folds   = 1
let g:taskwiki_taskrc_location       = '~/.config/task/taskrc'

augroup VimwikiDiaryTemplate
  autocmd!
  autocmd BufNewFile ~/*/diary/*.wiki :silent call vimwiki_diary#Template()
augroup END
