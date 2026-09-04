let s:jira_email_users = '~/.local/share/jira/users.txt'
let s:jira_email_cache = []

function! jira#Issue(issue = expand('<cWORD>'))
  return matchstr(a:issue, '\v(\zs[A-Za-z]+-\d+\ze)')
endfunction

function! jira#Url(issue = expand('<cWORD>'))
  return 'https://tealium.atlassian.net/browse/' . jira#Issue(a:issue)
endfunction

function! jira#Browse(issue = expand('<cWORD>'))
  execute '!open ' . jira#Url(a:issue)
endfunction

function! jira#View(issue = expand('<cWORD>'))
  execute '!jira view ' . jira#Issue(a:issue)
endfunction

function! jira#PullRequests(issue = expand('<cWORD>'))
  execute '!jira prs ' . jira#Issue(a:issue)
endfunction

function! jira#Yank(issue = expand('<cWORD>'))
  let @* = jira#Url(a:issue)
endfunction

function! jira#Summary(issue = expand('<cWORD>')) abort
  let l:issue          = jira#Issue(a:issue)
  let l:summary        = system('jira view ' . l:issue . ' -t fields | jq -r .fields.summary | tr -d "\n"')
  let l:iskeyword_save = &l:iskeyword

  try
    setlocal iskeyword=45,48-57,65-90,97-122
    execute 'normal ciw' . l:issue . ': ' . l:summary
  catch
    return 'echoerr ' . string(v:exception)
  finally
    let &l:iskeyword = l:iskeyword_save
  endtry

  return ''
endfunction

function! jira#Complete(findstart, base)
  if a:findstart
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\k'
      let start -= 1
    endwhile
    return start
  else
    let results = []

    if getline(line('.') - 1) =~# '# Values:'
      let results = split(substitute(getline(line('.') - 1), '^.*# Values:\s*', '', ''), '\s*,\s*')
    endif

    if getline('.') =~# 'emailAddress:'
      if empty(s:jira_email_cache)
        let s:jira_email_cache = readfile(expand(s:jira_email_users))
      endif

      let results = copy(s:jira_email_cache)
    endif

    return filter(results, 'v:val =~ "^" . a:base')
  endif
endfunction
