setlocal complete=.,w,b,u,t,i
setlocal comments-=s1:/*,mb:*,ex:*/
setlocal comments+=fb:*
setlocal equalprg=perltidy
setlocal keywordprg=pd
setlocal iskeyword+=:,$,@,%
setlocal matchpairs+=<:>,«:»

"map <buffer> <Leader>r :call RunScript('-w')<CR>
"map <buffer> <Leader>b :call RunScript('-d')<CR>
"map <buffer> <Leader>c :!perlcritic %<CR>
"map <buffer> <Leader>d :!perldoc -F %<CR>
"map <buffer> <Leader>t :!clear; prove -blmv % \| more<CR>

iabbrev <buffer> dbs $DB::single = 1;
iabbrev <buffer> rov Readonly my => X;<Esc>?my<CR>/X<CR>``la
iabbrev <buffer> ubm use Benchmark qw( cmpthese );<CR><CR>cmpthese -10, {<CR>};<Esc>O
iabbrev <buffer> usc use Smart::Comments;<CR><CR>### 
iabbrev <buffer> UDD use Data::Dumper;<CR>warn Dumper;<Esc>i
iabbrev <buffer> udg use Data::Dumper::GUI;<CR>warn Dumper;<Esc>i
iabbrev <buffer> udd use Data::Dump;<CR>dd;<Esc>i
iabbrev <buffer> udc use Data::Dump::Color;<CR>dd;<Esc>i
iabbrev <buffer> udp use Data::Printer;<CR>p;<Esc>i
iabbrev <buffer> uds use Data::Show;<CR>show;<Esc>i
iabbrev <buffer> hdd use Data::HexDump 'HexDump';<CR>warn HexDump;<Esc>i

match ErrorMsg /_ref[\[{(]/

" TODO: http://blogs.perl.org/users/ovid/2011/06/syntax-highlight-your-sql-heredocs-in-vim.html
" TODO: http://blogs.perl.org/users/su-shee/2012/04/a-little-help-in-vim.html
" TODO: http://blogs.perl.org/users/davewood/2012/06/open-module-under-cursor-in-vim.html
" TODO: http://blogs.perl.org/users/ovid/2012/07/integrating-perlcritic-and-vim.html
