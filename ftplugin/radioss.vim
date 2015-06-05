"-------------------------------------BOF---------------------------------------
"
" Vim filetype plugin file
"
" Language:     Radioss FE solver input file
" Maintainer:   Bartosz Gradzik <bartosz.gradzik@hotmail.com>
" Last Change:  1st of March 2015
" Version:      1.0.0
"
" History of change:
"
" v1.0.1
"   - function Comment updated to support #include keyword
" v1.0.0
"   - initial version
"
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
"    FILETYPE PLUGIN SETTINGS
"-------------------------------------------------------------------------------

" check if the plugin is already load into current buffer
if exists("b:did_ftplugin") | finish | endif
" set flag when the filetype plugin is loaded
let b:did_ftplugin = 1
" save current compatible settings
let s:cpo_save = &cpo
" reset vim to default settings
set cpo&vim

"-------------------------------------------------------------------------------
"    COLORS
"-------------------------------------------------------------------------------

"load colors
colorscheme radioss

"-------------------------------------------------------------------------------
"    PREFERED TAB SETTINGS
"-------------------------------------------------------------------------------

" use spaces instead tab
setlocal expandtab
" set tab width to 10
setlocal tabstop=10
" set width for < > commands
setlocal shiftwidth=10
" do not remove tab space equvivalent but only one sign
setlocal softtabstop=0
" allow for virtual columns
setlocal virtualedit=all
" set text width
setlocal textwidth=100

"-------------------------------------------------------------------------------
"    FOLDING
"-------------------------------------------------------------------------------

" Fold all lines that do not begin with / (keyword),# and $ (comment)
setlocal foldexpr=getline(v:lnum)!~?\"\^[/#$]\"
setlocal foldmethod=expr
setlocal foldminlines=4

"-------------------------------------------------------------------------------
"    INCLUDE
"-------------------------------------------------------------------------------

" define include keyword
"setlocal include=\\c^#include
" remove #include keyword, leave just path
setlocal includeexpr=substitute(v:fname,'#include\s*','','')
" open in current window
nnoremap <silent><buffer> gf Vgf
" open in new window
nnoremap <silent><buffer> gF V<C-w>f<C-w>H

"-------------------------------------------------------------------------------
"    USEFUL MAPPINGS
"-------------------------------------------------------------------------------

function! RadiossComment()
  if getline('.')[0] == '3'
    normal! hx
    return '#'
  else
    return ''
  endif
endfunction
" change 3 -> # but only at the beginning of the line
inoreabbrev 3 3<C-R>=RadiossComment()<CR>

" mapping for separation lines
nnoremap <silent><buffer> <LocalLeader>c o#<ESC>0
nnoremap <silent><buffer> <LocalLeader>C O#<ESC>0
nnoremap <silent><buffer> <LocalLeader>1 o#<ESC>99a-<ESC>0
nnoremap <silent><buffer> <LocalLeader>! O#<ESC>99a-<ESC>0
nnoremap <silent><buffer> <LocalLeader>2 o
 \#---1----\|----2----\|----3----\|----4----\|----5----\|
 \----6----\|----7----\|----8----\|----9----\|---10----\|<ESC>0
nnoremap <silent><buffer> <LocalLeader>@ O
 \#---1----\|----2----\|----3----\|----4----\|----5----\|
 \----6----\|----7----\|----8----\|----9----\|---10----\|<ESC>0
nnoremap <silent><buffer> <LocalLeader>3 o
 \#--------1---------2---------3---------4---------5
 \---------6---------7---------8---------9--------10<ESC>0
nnoremap <silent><buffer> <LocalLeader>$ O
 \#--------1---------2---------3---------4---------5
 \---------6---------7---------8---------9--------10<ESC>0
nnoremap <silent><buffer> <LocalLeader>0 o#<ESC>99a-<ESC>yypO#<ESC>A    
nnoremap <silent><buffer> <LocalLeader>) O#<ESC>99a-<ESC>yypO#<ESC>A    

" jump to previous keyword
nnoremap <silent><buffer> [[ ?^\/\a<CR>:nohlsearch<CR>zz
" jump to next keyword
nnoremap <silent><buffer> ]] /^\/\a<CR>:nohlsearch<CR>zz

" abbreviation
inoreabbrev #i #include
inoreabbrev #e #enddata
inoreabbrev #r #RADIOSS Starter

"-------------------------------------------------------------------------------
"    INCLUDES
"-------------------------------------------------------------------------------

" always set current working directory respect to open file
augroup radioss
  autocmd!
  " set working directory to current file
  cd %:p:h
  autocmd BufNewFile * cd %:p:h
  autocmd BufReadPost * cd %:p:h
  autocmd WinEnter * cd %:p:h
  autocmd TabEnter * cd %:p:h
  autocmd BufWrite * set ff=unix

  " VIM loads radiance syntax file from default installation for *.rad files
  " and overwrites default iskeyword settings. Here I am reseting them.
  autocmd BufNewFile * setlocal iskeyword&
  autocmd BufReadPost * setlocal iskeyword&
  autocmd WinEnter * setlocal iskeyword&
  autocmd TabEnter * setlocal iskeyword&

augroup END

"-------------------------------------------------------------------------------
"    COMMENT FUNCTION
"-------------------------------------------------------------------------------

" prefered Alt-C but not always works ...
noremap <silent><buffer> <M-c> :call <SID>Comment()<CR>j
" ... use Ctrl-C instead
noremap <silent><buffer> <C-c> :call <SID>Comment()<CR>j

function! <SID>Comment() range

  " get firstline from selection
  let line = getline(a:firstline)

  " include line
  if line =~? "^#include"
    if line =~? "^##"
      silent execute a:firstline . ',' . a:lastline . 's/^\#//'
    else
      silent execute a:firstline . ',' . a:lastline . 's/^/#/'
    endif

  " comment line
  else
    if line =~? "^#"
      silent execute a:firstline . ',' . a:lastline . 's/^\#//'
    else
      silent execute a:firstline . ',' . a:lastline . 's/^/#/'
    endif
  endif

endfunction

"-------------------------------------------------------------------------------
"    TEXT OBJECTS
"-------------------------------------------------------------------------------

" around keyword (ak) and insert keyword (ik) works the same
vnoremap <buffer><script><silent> ik :call <SID>KeywordTextObj()<CR>
onoremap <buffer><script><silent> ik :call <SID>KeywordTextObj()<CR>
vnoremap <buffer><script><silent> ak :call <SID>KeywordTextObj()<CR>
onoremap <buffer><script><silent> ak :call <SID>KeywordTextObj()<CR>

function! s:KeywordTextObj()

 let reKeyWord  = "^/\\a"
 let reDataLine = "^[^#]\\|^$"

 " go to end of the line
  normal! $
  " find keyword in backword
  call search(reKeyWord,'bW')
  " start line visual mode
  normal! V
  " serach next keyword
  let res = search(reKeyWord, 'W')
  " go to the end of file if you did not find the keyword
  if res == 0
    normal! G
  endif
  " move back to first data line
  call search(reDataLine,'bW')

endfunction

"-------------------------------------------------------------------------------
"    KEYWORDS LIBRARY
"-------------------------------------------------------------------------------

" allow to use Ctrl-Tab for user completion
inoremap <C-Tab> <C-X><C-U>

" set using popupmenu for completion
setlocal completeopt+=menu
setlocal completeopt+=menuone

" set path to keyword library directory
if !exists("g:radiossLibPath")
  let g:radiossKeyLibPath = expand('<sfile>:p:h:h') . '/keywords/'
endif

" initialize radioss keyword library
" the library is initilized only once per Vim session
if !exists("g:radiossKeyLib")
  let g:radiossKeyLib = radioss_library#initLib(g:radiossKeyLibPath)
endif

" set user completion flag
let b:radiossUserComp = 0

" set user completion function to run with <C-X><C-U>
setlocal completefunc=radioss_library#CompleteKeywords

" mapping for <CR>/<C-Y>/<kEnter>
" if g:radiossUserComp is true run GetCompletion function
" if g:radiossUserComp is false act like <CR>/<C-Y>/<kEnter>
inoremap <buffer><silent><script><expr> <CR>
 \ b:radiossUserComp ? "\<ESC>:call radioss_library#GetCompletion()\<CR>" : "\<CR>"
inoremap <buffer><silent><script><expr> <C-Y>
 \ b:radiossUserComp ? "\<ESC>:call radioss_library#GetCompletion()\<CR>" : "\<C-Y>"
inoremap <buffer><silent><script><expr> <kEnter>
 \ b:radiossUserComp ? "\<ESC>:call radioss_library#GetCompletion()\<CR>" : "\<kEnter>"

" act <up> and <down> like Ctrl-p and Ctrl-n
inoremap <buffer><silent><script><expr> <Down>
 \ pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <buffer><silent><script><expr> <Up>
 \ pumvisible() ? "\<C-p>" : "\<Up>"

"-------------------------------------------------------------------------------
"    LINE FORMATING
"-------------------------------------------------------------------------------

noremap <buffer><script><silent> <LocalLeader><LocalLeader>
 \ :call radioss_autoformat#RadiossLine()<CR>

"-------------------------------------------------------------------------------
"    CURVE COMMANDS
"-------------------------------------------------------------------------------

command! -buffer -range -nargs=* RadiossShift
 \ :call radioss_curves#Shift(<line1>,<line2>,<f-args>)

command! -buffer -range -nargs=* RadiossScale
 \ :call radioss_curves#Scale(<line1>,<line2>,<f-args>)

command! -buffer -range -nargs=* RadiossResample
 \ :call radioss_curves#Resample(<line1>,<line2>,<f-args>)

command! -buffer -range -nargs=* RadiossAddPoint
 \ :call radioss_curves#AddPoint(<line1>,<line2>,<f-args>)

command! -buffer -range RadiossSwap
 \ :call radioss_curves#Swap(<line1>,<line2>)

command! -buffer -range RadiossReverse
 \ :call radioss_curves#Reverse(<line1>,<line2>)

"-------------------------------------------------------------------------------
" restore vim functions
let &cpo = s:cpo_save

"-------------------------------------EOF---------------------------------------
