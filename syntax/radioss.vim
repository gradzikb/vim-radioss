"-------------------------------------BOF---------------------------------------
"
" Vim syntax file
"
" Language:     Radioss FE solver input file
" Maintainer:   Bartosz Gradzik (bartosz.gradzik@hotmail.com)
" Contribution: Jakub Pajerski
" Last Change:  1st of March 2015
"
" History of change:
"
" v1.0.0
"   - initial version
"
"-------------------------------------------------------------------------------

" check if syntax is already loaded
if exists("b:current_syntax") | finish | endif
" set flag when ls-dyna syntax is loaded
let b:current_syntax = "radioss"

"-------------------------------------------------------------------------------
"    Items shared among keywords
"-------------------------------------------------------------------------------

syntax match RadiossComment '^[$#].*$'
syntax match RadiossTitle '^\(\a\|?\|\.\).*$' contained
syntax match RadiossKeyword '^\/\(\a\|/\).*$' contained

highlight default link RadiossComment Comment
highlight default link RadiossKeyword Statement
highlight default link RadiossTitle Identifier

"-------------------------------------------------------------------------------
"    Standard Ls-Dyna keyword
"-------------------------------------------------------------------------------

syntax match RadiossStdKeyword_02_Col '\%11c.\{10}' contained
syntax match RadiossStdKeyword_04_Col '\%31c.\{10}' contained
syntax match RadiossStdKeyword_06_Col '\%51c.\{10}' contained
syntax match RadiossStdKeyword_08_Col '\%71c.\{10}' contained
syntax match RadiossStdKeyword_10_Col '\%91c.\{10}' contained

highlight default link RadiossStdKeyword_02_Col Error
highlight default link RadiossStdKeyword_04_Col Error
highlight default link RadiossStdKeyword_06_Col Error
highlight default link RadiossStdKeyword_08_Col Error
highlight default link RadiossStdKeyword_10_Col Error

syntax cluster RadiossStdKeywordCluster add=RadiossComment
syntax cluster RadiossStdKeywordCluster add=RadiossKeyword
syntax cluster RadiossStdKeywordCluster add=RadiossTitle
syntax cluster RadiossStdKeywordCluster add=RadiossStdKeyword_02_Col
syntax cluster RadiossStdKeywordCluster add=RadiossStdKeyword_04_Col
syntax cluster RadiossStdKeywordCluster add=RadiossStdKeyword_06_Col
syntax cluster RadiossStdKeywordCluster add=RadiossStdKeyword_08_Col
syntax cluster RadiossStdKeywordCluster add=RadiossStdKeyword_10_Col

syntax region RadiossStdKeyword start=/^\/\a/ end=/^\//me=s-1
 \ contains=@RadiossStdKeywordCluster

"-------------------------------------EOF---------------------------------------
