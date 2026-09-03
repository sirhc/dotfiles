" -s,  --simplify              simplify the code
" -ln, --language-dialect str  bash/posix/mksh/bats, default "auto"
" -i,  --indent uint           0 for tabs (default), >0 for number of spaces
" -bn, --binary-next-line      binary ops like && and | may start a line
" -ci, --case-indent           switch cases will be indented
" -sr, --space-redirects       redirect operators will be followed by a space
" -kp, --keep-padding          keep column alignment paddings
let &l:formatprg='shfmt -s -ln bash -i ' . &l:shiftwidth . ' -bn -ci -sr -kp'
