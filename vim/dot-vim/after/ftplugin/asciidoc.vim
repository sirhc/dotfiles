if has('folding') && exists('g:asciidoc_folding')
  setlocal foldexpr=AsciidocFold()
  setlocal foldlevel=1
  setlocal foldlevelstart=1
  setlocal foldmethod=expr
endif

let b:runscript_interpreter = 'asciidoc'

function! AsciidocFold()
  let line  = getline(v:lnum)
  let depth = match(line, '\(^=\+\)\@<=\( .*$\)\@=')

  if depth > 0
    return '>' . depth
  endif

  return '='
endfunction
