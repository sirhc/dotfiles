set autoindent
set autowriteall
set backspace=indent,eol,start
set directory=~/.vim/swapfiles//,~/tmp//,.
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

set laststatus=2   " Always display the statusline in all windows
set showtabline=2  " Always display the tabline, even if there is only one tab
set noshowmode     " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set t_Co=256

if v:version >= 700
    set cursorline
end

let mapleader = ','

" http://vim.wikia.com/wiki/Disable_F1_built-in_help_key
nmap <F1> :echo<CR>
imap <F1> <C-o>:echo<CR>

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

if &t_Co > 2
    syntax on
endif

if &diff
    " Make vimdiff easier to read on a dark terminal.
    highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
    highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
    highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
    highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

    set nospell
endif

nmap <F3>      :set invnumber<CR>
nmap <F4>      :set invspell<CR>
nmap <F5>      :if exists("g:syntax_on") <Bar> syntax off <Bar> else <Bar> syntax enable <Bar> endif <CR>
nmap <F6>      :SyntasticToggleMode<CR>
nmap <F7>      :SyntasticCheck<CR>
nmap <BS>      :nohlsearch<CR>
nmap <Up>      :bprev<CR>
nmap <Down>    :bnext<CR>
nmap <Left>    :cprev<CR>
nmap <Right>   :cnext<CR>
nmap <Space>   <PageDown>
nmap <Leader>d :!perldoc "%"<CR>
nmap <Leader>f :NERDTreeToggle<CR>
nmap <Leader>g :Geeknote<CR>
nmap <Leader>l :RainbowLevelsToggle<CR>
nmap <Leader>r :call RunScript()<CR>
" navigate through wrapped lines
"nnoremap j gj
"nnoremap k gk

" Toggle highlight when refreshing the screen.
"
" <https://twitter.com/gumnos/status/1282057172763934720>
nnoremap <C-L> :set hls!<CR><C-L>

" http://robots.thoughtbot.com/post/619330025/viiiiiiiiiiiiiiiiiim
"
" In visual mode, duplicate selection directly below. Handy when writing
" tests.
xmap D y'>p

" http://vim.wikia.com/wiki/Insert_current_filename
"
"inoremap \fn <C-R>=expand("%:t")<CR>

" http://mislav.uniqpath.com/2011/12/vim-revisited/
"
nnoremap <Leader><Leader> <C-^>

" http://www.catonmat.net/blog/sudo-vim/
cnoremap sudow w !sudo tee % >/dev/null

if has("gui_running")
    set columns=85 lines=45
    set guioptions-=m   " hide menubar
    set guioptions-=T   " hide toolbar

    if has("win32")
        set guifont=Lucida_Sans_Typewriter:h9:cANSI
    elseif has("gui_gtk2") || has("gui_gtk3")
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

"function! RpmDate()
"    exec !date +'%a %b %d %Y'
"endfunction

augroup OpenFile
    au!

    " When editing an existing file, always jump to the last cursor position.
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     exe "normal! g'\"" |
        \ endif

    " Prevent swap files in the Dropbox directory, otherwise they will be
    " synced. (This is unnecessary with dir=~/tmp.)
    "au BufNewFile,BufRead ~/Dropbox/* set noswapfile

    " Start new files with a template, if one exists (and remove the empty
    " line at the end).
    au BufNewFile * silent! 0r ~/.vim/template/new.%:e
    au BufNewFile * silent! normal Gdd

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

"if v:version >= 700
"    runtime bundle/vim-pathogen/autoload/pathogen.vim
"    if exists("g:loaded_pathogen")
"        call pathogen#infect()
"    endif
"end

let g:NERDTreeIgnore      = ['\.o$', '\.class$', '\.pyc$', '\~$', '^__pycache__$', '\.tfstate\(\|\..*\)$']
let g:NERDTreeHijackNetrw = 1
let g:NERDTreeMinimalMenu = 1  " https://github.com/preservim/nerdtree/issues/1321

" Ref: <https://github.com/scrooloose/syntastic>
"
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
" Emulate standard status line with 'ruler' set
"   :set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

"set statusline=\[%n\]\ %<%f\ %y\ %{FugitiveStatusline()}\ %h%m%r\ %#warningmsg#%{SyntasticStatuslineFlag()}%*%=%-14.(%l,%c%V%)\ %P

let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cloudformation_checkers = ['cfn_lint', 'cfn_nag']
let g:syntastic_markdown_checkers = ['mdl', 'proselint']
let g:syntastic_perl_perlcritic_post_args = '--verbose "\%s:\%f:\%l:\%c: \%p (\%s): \%m\n"'  " https://github.com/scrooloose/syntastic/wiki/%28v3.7.0%29---Perl%3A---perlcritic
let g:syntastic_python_checkers = ['python', 'flake8']
let g:syntastic_yaml_checkers = ['yamllint', 'yamlxs']

let g:terraform_align         = 0
let g:terraform_fold_sections = 0
let g:terraform_fmt_on_save   = 0

" http://vim.wikia.com/wiki/Switching_case_of_characters
"
" With the following, you can visually select text then press ~ to convert the
" text to UPPER CASE, then to lower case, then to Title Case. Keep pressing ~
" until you get the case you want.

function! TwiddleCase(str)
    if a:str ==# toupper(a:str)
        let l:result = tolower(a:str)
    elseif a:str ==# tolower(a:str)
        let l:result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
    else
        let l:result = toupper(a:str)
    endif

    return l:result
endfunction

xnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv

" https://vim.fandom.com/wiki/Folding
inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf

" Testing out simplified window navigation.
nmap <silent> <C-Up>    :wincmd k<CR>
nmap <silent> <C-Down>  :wincmd j<CR>
nmap <silent> <C-Left>  :wincmd h<CR>
nmap <silent> <C-Right> :wincmd l<CR>

" Testing out vim-airline.
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
"let g:airline_theme = 'molokai'
let g:airline_section_x = '%{ScrollStatus()}'

if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif
