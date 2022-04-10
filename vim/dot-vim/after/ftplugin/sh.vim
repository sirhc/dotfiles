if executable('shfmt')
    let &l:formatprg='shfmt -i ' . &l:shiftwidth . ' -sr -ci -s'
endif
