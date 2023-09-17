if exists('b:current_syntax')
 finish
endif

syn include @ShellScript syntax/zsh.vim

" https://github.com/denisidoro/navi/blob/master/docs/cheatsheet_syntax.md#syntax-overview
syn match naviTags '^%.*$' contains=@NoSpell,naviTag
syn match naviDescription '^#.*'

" $ name: command --- options
syn match naviArgument "^\$.*$" contains=naviArgumentCommand,naviArgumentOptions
syn match naviArgumentCommand "\(:\)\@<=.*$" contained contains=@ShellScript
syn match naviArgumentCommand "\(:\)\@<=.*\(---\)\@=" contained contains=@ShellScript
syn match naviArgumentOptions "\(---\)\@<=.*$" contained contains=@ShellScript

syn match naviComment '^;.*'
syn match naviAssociatedTags '^@.*' contains=@NoSpell
syn match naviCommand '^[^%#;$@].*' contains=@ShellScript

hi def link naviTags Type
hi def link naviAssociatedTags Include
hi def link naviDescription Label
hi def link naviComment Comment
hi def link naviArgument Identifier

let b:current_syntax = 'navi'
