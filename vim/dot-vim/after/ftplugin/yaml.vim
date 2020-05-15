let b:interpreter = 'yq r'

setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2

if (&filetype == 'yaml.cloudformation')
    let g:syntastic_cloudformation_checkers = ['cfn-lint', 'cfn_nag']
endif
