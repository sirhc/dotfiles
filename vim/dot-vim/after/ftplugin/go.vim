setlocal equalprg=gofmt
setlocal formatprg=gofmt
setlocal keywordprg=godoc

let b:runscript_interpreter = "go run"

nmap <Leader>t :!clear; go test -v \| less<CR>
