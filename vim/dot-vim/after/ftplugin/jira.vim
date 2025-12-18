let s:jira_email_users = '~/.local/share/jira/users.txt'
let s:jira_email_cache = []

function! JiraComplete(findstart, base)
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

setlocal omnifunc=JiraComplete
