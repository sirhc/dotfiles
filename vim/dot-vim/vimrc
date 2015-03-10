set autoindent
set autowriteall
set backspace=indent,eol,start
set expandtab
set foldmethod=marker
set formatoptions+=n
set history=50
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set listchars=eol:$,tab:..,trail:.,extends:>,precedes:<
set more
set number
set pastetoggle=<F2>
set report=0
set ruler
set shiftround
set shiftwidth=4
set smartcase
set smartindent
set smarttab
set spell
set softtabstop=4
set tabstop=4
set textwidth=78
set timeout timeoutlen=300 ttimeoutlen=300  " keycodes and maps timeout in 3/10 sec
set title
set viminfo='20,<50,s10,h
set wildmode=list:longest,full

set nocompatible
set nojoinspaces
set nolist
set nostartofline

if v:version >= 700
    set cursorline
end

let mapleader = ','

" http://blog.nixpanic.net/2013/01/changing-vim-settings-depending-on-git.html
"
" $ git config --add vim.modeline 'tabstop=4 expandtab'
"
let s:git_modeline = system("git config --get vim.modeline")
if strlen(s:git_modeline)
    exe "set" s:git_modeline
endif

filetype plugin on
filetype indent on

if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
    set t_Co=256
endif

if &t_Co > 2
    syntax on
endif

nmap <F3>      :set invnumber<CR>
nmap <F4>      :set invspell<CR>
nmap <BS>      :nohlsearch<CR>
nmap <Up>      :bprev<CR>
nmap <Down>    :bnext<CR>
nmap <Left>    :cprev<CR>
nmap <Right>   :cnext<CR>
nmap <Space>   <PageDown>
nmap <Leader>f :NERDTreeToggle<CR>
nmap <Leader>r :call RunScript()<CR>
" navigate through wrapped lines
"nnoremap j gj
"nnoremap k gk

" http://robots.thoughtbot.com/post/619330025/viiiiiiiiiiiiiiiiiim
"
" In visual mode, duplicate selection directly below. Handy when writing
" tests.
vmap D y'>p

" http://vim.wikia.com/wiki/Insert_current_filename
"
"inoremap \fn <C-R>=expand("%:t")<CR>

" http://mislav.uniqpath.com/2011/12/vim-revisited/
"
nnoremap <Leader><Leader> <C-^>

" http://www.catonmat.net/blog/sudo-vim/
cnoremap sudow w !sudo tee % >/dev/null

if has("gui_running")
    colorscheme torte

    set columns=80 lines=40
    set guioptions-=m   " hide menubar
    set guioptions-=T   " hide toolbar

    if has("win32")
        set guifont=Lucida_Sans_Typewriter:h9:cANSI
    elseif has("gui_gtk2")
        set guifont=Inconsolata\ Medium\ 10
    else
        set guifont=-b&h-lucida\ sans\ typewriter-medium-r-normal-*-*-120-*-*-m-*-iso8859-1
    endif

    function! ToggleMenuToolbar()
        if &guioptions =~# 'T'
            set guioptions-=T
            set guioptions-=m
        else
            set guioptions+=T
            set guioptions+=m
        endif
    endfunction

    nmap <silent> <F4> :call ToggleMenuToolbar()<CR>

    " Make shift-insert work like in a terminal.
    imap <S-Insert> <MiddleMouse>
    cmap <S-Insert> <MiddleMouse>
endif

" Handy abbreviations.
iabbrev fiancee fiancée
iabbrev naiive  naïve
iabbrev nee     née
iabbrev passee  passé
iabbrev resumee résumé
iabbrev touchee touché

" Common typos.
iabbrev absense   absence
iabbrev acheive   achieve
iabbrev acheived  achieved
iabbrev teh       the
iabbrev dont'     don't
iabbrev existance existence
iabbrev paramter  parameter

" Highlight trailing whitespace.
match ErrorMsg /\s\+\%#\@!$/    " \s\+  one or more whitespace characters
                                " \%#   current cursor position
                                " \@!   zero-width match if previous fails
                                " $     end of line

if has("perl")
    " From freenode/#perl:
    " 01/05/11 07:34:56 < grondilu> add "perl *say = \&VIM::Msg" in your
    "                               .vimrc and you'll spare 5 chars each time
    "                               you'll want to see the ouput of a :perl
    "                               command :)
    perl *say = \&VIM::Msg
endif

augroup OpenFile
    au!

    " When editing an existing file, always jump to the last cursor position.
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     exe "normal! g'\"" |
        \ endif

    " Prevent swap files in the Dropbox directory, otherwise they will be
    " synced.
    au BufNewFile,BufRead ~/Dropbox/* set noswapfile

    " Start new files with a template, if one exists (and remove the empty
    " line at the end).
    au BufNewFile * silent! 0r ~/.vim/template/new.%:e
    au BufNewFile * silent! normal Gdd

    " Use whichever script interpreter is in PATH.
    au BufNewFile *.pl silent! 1s/^#!.*/\="#!" . substitute(system("which perl"), "\n", "", "")/
    au BufNewFile *.py silent! 1s/^#!.*/\="#!" . substitute(system("which python"), "\n", "", "")/

    au BufNewFile,BufRead known_hosts set nowrap nospell

    " View various files types (see Vim tip #1356).
    au BufReadPre  *.pdf setlocal ro
    au BufReadPost *.pdf %!pdftotext -nopgbrk "%" -

    au BufReadPre  *.rtf setlocal ro
    au BufReadPost *.rtf %!unrtf -t text "%"

    au BufReadPre  *.rpm setlocal ro
    au BufReadPost *.rpm %!rpm -qilp "%"

    au BufReadPre  *.gpg setlocal ro
    au BufReadPost *.gpg %!gpg --decrypt "%" -

    au BufReadPre *.epub setlocal ro
    au BufReadCmd *.epub call zip#Browse(expand("<amatch>"))

    au BufNewFile,BufRead *.t let b:interpreter = "prove -v"
augroup END

if v:version >= 700
    runtime bundle/vim-pathogen/autoload/pathogen.vim
    if exists("g:loaded_pathogen")
        call pathogen#infect()
    endif
end
