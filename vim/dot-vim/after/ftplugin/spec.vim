setlocal textwidth=80

map <buffer> <Leader>bp :!clear; rpmbuild -bp "%"<CR>
map <buffer> <Leader>bc :!clear; rpmbuild -bc "%"<CR>
map <buffer> <Leader>ba :!clear; rpmbuild -ba "%"<CR>
map <buffer> <Leader>dt :r!date +"\%a \%b \%d \%Y"<CR>
