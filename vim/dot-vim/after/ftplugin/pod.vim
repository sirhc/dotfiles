scriptencoding utf-8

let b:runscript_interpreter = 'perldoc -F'

setlocal cinwords=
setlocal comments+=fb:*
setlocal comments-=s1:/*,mb:*,ex:*/
setlocal equalprg=podtidy
setlocal iskeyword+=:
setlocal keywordprg=pd
setlocal matchpairs+=<:>,«:»,=:;
