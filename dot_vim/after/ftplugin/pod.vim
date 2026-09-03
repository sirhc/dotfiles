scriptencoding utf-8

let b:runscript_interpreter = 'perldoc -F'

setlocal cinwords=
setlocal comments+=fb:*
setlocal comments-=s1:/*,mb:*,ex:*/
setlocal formatprg=podtidy
setlocal iskeyword+=:
setlocal matchpairs+=<:>,«:»,=:;
