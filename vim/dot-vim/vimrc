set autochdir
set autoindent
set autoread
set autowriteall
set backspace=indent,eol,start
set cursorline
set directory=~/.vim/swapfiles//,~/tmp//,.
set display=lastline
set expandtab
set foldmethod=marker
set formatoptions+=n
set history=50
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set laststatus=2   " Always display the statusline in all windows
set linebreak
set listchars=eol:$,tab:..,trail:.,extends:>,precedes:<
set more
set number
set pastetoggle=<F2>
set report=0
set scrolloff=5
set shiftround
set shiftwidth=4
set showtabline=2  " Always display the tabline, even if there is only one tab
set sidescrolloff=10
set smartcase
set smartindent
set smarttab
set smoothscroll
set softtabstop=4
set spell
set tabstop=4
set textwidth=78
set timeout timeoutlen=300 ttimeoutlen=300   " keycodes and maps timeout in 3/10 sec
set title
set undodir=~/.vim/undofiles//,~/tmp//,.
set undofile
set viminfo='20,<50,s10,h
set wildignorecase
set wildmode=list:longest,full
set wildoptions=pum

set nocompatible
set nojoinspaces
set nolist
set noshowmode  " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set nostartofline

set t_Co=256
set t_ut=

" Emulate Vim's modeline support using `git config`. For example,
"
" > git config --add vim.modeline 'tabstop=4 expandtab'

let s:git_modeline = system('git config --get vim.modeline')
if strlen(s:git_modeline)
    execute 'set ' . s:git_modeline
endif

let g:codedark_italics     = 1
let g:codedark_modern      = 1
let g:codedark_transparent = 1
silent! colorscheme codedark  " https://vimcolorschemes.com/tomasiser/vim-code-dark

filetype plugin indent on
syntax on

nnoremap <silent> <F3>      :set invnumber<CR>
nnoremap <silent> <F4>      :set invspell<CR>
nnoremap <silent> <F5>      :update<CR> :call RunScript()<CR>
nnoremap <silent> <F6>      :update<CR> :make<CR>
nnoremap <silent> <F9>      :if exists("g:syntax_on") <Bar> syntax off <Bar> else <Bar> syntax enable <Bar> endif <CR>
inoremap <silent> <F10>     <C-O>za
nnoremap <silent> <F10>     za
onoremap <silent> <F10>     <C-C>za
vnoremap <silent> <F10>     zf
nnoremap <silent> <BS>      :nohlsearch<CR>
nnoremap <silent> <Up>      :bprev<CR>
nnoremap <silent> <Down>    :bnext<CR>
nnoremap <silent> <Left>    :cprev<CR>
nnoremap <silent> <Right>   :cnext<CR>
nnoremap <silent> <Space>   <PageDown>

" Quick window navigation using Ctrl+<Arrow>.
nnoremap <silent> <C-Up>    :wincmd k<CR>
nnoremap <silent> <C-Down>  :wincmd j<CR>
nnoremap <silent> <C-Left>  :wincmd h<CR>
nnoremap <silent> <C-Right> :wincmd l<CR>

nnoremap <silent> <Leader>aj :ALENextWrap<CR>
nnoremap <silent> <Leader>ak :ALEPreviousWrap<CR>

" Always navigate through wrapped lines.
nnoremap j gj
nnoremap k gk

" Duplicate the selection directly below.
vnoremap <Leader>dd y'>p

" List buffers and prompt to switch with a number (g = go to).
nnoremap <Leader>g :buffers<CR>:buffer<Space>

" http://vim.wikia.com/wiki/Switching_case_of_characters
vnoremap ~ y:call setreg('', twiddlecase#TwiddleCase(@"), getregtype(''))<CR>gv""Pgv

cnoremap sudow w !sudo tee % >/dev/null

" Handy abbreviations.
iabbrev fiancee fiancée
iabbrev naiive  naïve
iabbrev nee     née
iabbrev passee  passé
iabbrev resumee résumé
iabbrev touchee touché

iabbrev Rohai   Rōhai
iabbrev rohai   Rōhai

" Common typos.
iabbrev absense   absence
iabbrev acheive   achieve
iabbrev acheived  achieved
iabbrev teh       the
iabbrev dont'     don't
iabbrev existance existence
iabbrev paramter  parameter

if has("perl")
    " freenode #perl 2011-01-05 07:34:56 < grondilu> add "perl *say = \&VIM::Msg" in your .vimrc and you'll spare 5 chars each time you'll want to see the ouput of a :perl command :)
    perl *say = \&VIM::Msg
endif

augroup ReadFile
    autocmd!

    " When editing an existing file, always jump to the last cursor position.
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     exe "normal! g'\"" |
        \ endif

    " Tricks to view various non-text file types.

    if executable('gpg')
        autocmd BufReadPre  *.gpg setlocal ro
        autocmd BufReadPost *.gpg silent execute '%!gpg --decrypt' shellescape(expand('%')) '-'
    endif

    if executable('pdftotext')
        autocmd BufReadPre  *.pdf setlocal ro
        autocmd BufReadPost *.pdf silent execute '%!pdftotext -layout -nopgbrk' shellescape(expand('%')) '-'
    endif

    if executable('rpm')
        autocmd BufReadPre  *.rpm setlocal ro
        autocmd BufReadPost *.rpm silent execute '%!rpm -qilp' shellescape(expand('%'))
    endif

    if executable('unrtf')
        autocmd BufReadPre  *.rtf setlocal ro
        autocmd BufReadPost *.rtf silent execute '%!unrtf -t text' shellescape(expand('%'))
    endif
augroup END

augroup QuickFix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost    l* lwindow
augroup END

let g:netrw_altfile      = 1    " CTRL-^ won't return to netrw
let g:netrw_altv         = 1    " right splitting
let g:netrw_banner       = 1    " show the netrw banner
let g:netrw_browse_split = 4    " act like "P"
let g:netrw_list_hide    = netrw_gitignore#Hide() .. ',^\..*'
let g:netrw_liststyle    = 3    " tree style listing
let g:netrw_sizestyle    = 'H'  " human-readable (1024 base)
let g:netrw_winsize      = 20   " 20% window size

" https://github.com/vim-airline/vim-airline

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_powerline_fonts                 = 1
let g:airline#extensions#tabline#enabled      = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline_symbols.space                   = "\ua0"
let g:airline_theme                           = 'codedark'

if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
    set grepformat+=%f:%l:%c:%m

    let g:ctrlp_user_command = 'rg %s --files --hidden --color=never --glob ""'
endif
if executable('fd')
    let g:ctrlp_user_command = 'fd --color=never --glob --type file "" %s'
endif

let wiki_1 = {}
let wiki_1.path = '~/vimwiki/'
let wiki_1.ext = '.md'
let wiki_1.syntax = 'markdown'
let wiki_1.automatic_nested_syntaxes = 1
let wiki_1.list_margin = 0
let wiki_1.auto_tags = 1

let g:vimwiki_list = [wiki_1]

let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 2
let g:vimwiki_global_ext = 0
let g:vimwiki_auto_chdir = 1

" Load a local configuration, if it exists. This allows for custom
" configuration per-host (e.g., for VimWiki).
runtime vimrc.local
