"setlocal noautoindent
setlocal cinwords=
"setlocal comments-=s1:/*
"setlocal comments-=mb:*
"setlocal comments-=ex:*/
"setlocal comments-=://
"setlocal comments-=fb:-
setlocal complete=k~/.vim/complete/mail.list,.,w,b,u,t,i
setlocal dictionary+=/usr/share/dict/words
"setlocal formatoptions+=waj
setlocal notitle
setlocal textwidth=72
setlocal keywordprg=dict

map <buffer> <C-J> !G perl -MText::Autoformat -e 'autoformat{mail=>1}'<CR>
map <buffer> <Leader>s Go-- <Esc>:r! ~/bin/signature<CR>
map <buffer> -- A<CR><CR><CR><Esc>k5i-----cut-----<Esc><CR><CR>
map <buffer> ] 0i> <Esc><CR>
