"-------------------------------------BOF---------------------------------------
"
" Vim filetype plugin file
"
" Language:     VIM Script
" Filetype:     Radioss FE solver input file
" Maintainer:   Bartosz Gradzik <bartosz.gradzik@hotmail.com>
" Last Change:  1st of March 2015
"
" History of changes:
"
" v1.0.0
"   - initial version
"
"-------------------------------------------------------------------------------

function! radioss_library#initLib(path)

  "-----------------------------------------------------------------------------
  " Function to initialize Radioss keyword library.
  "
  " Arguments:
  " - path (string) : path to directory with keyword files
  " Return:
  " - keyLib (dict) : keywords list
  "-----------------------------------------------------------------------------

  " get list of files in the library
  let keyLib = split(globpath(a:path, '**/*.rad'))
  " keep only file names without extension
  call map(keyLib, 'fnamemodify(v:val, ":t:r")')
  " substitute _ -> / (but not if it starts with '_')
  "call map(keyLib, 'substitute(v:val, "_", "/", "g")')
  for i in range(len(keyLib))
    if keyLib[i][0] != "_"
      let keyLib[i] = substitute(keyLib[i], "_", "/", "g")
    endif
  endfor

  return keyLib

endfunction

"-------------------------------------------------------------------------------

function! radioss_library#CompleteKeywords(findstart, base)

  "-----------------------------------------------------------------------------
  " User completion function used with keyword library.
  "
  " Arguments:
  " - see :help complete-functions
  " Return:
  " - see :help complete-functions
  "-----------------------------------------------------------------------------

  " run for first function call
  if a:findstart

    " find completion start
    if getline('.')[0] == "/"
      return 1
    else
      return 0
    endif

  else

    " completion loop
    let compKeywords = []
    for key in g:radiossKeyLib
      if key =~? '^' . a:base
        call add(compKeywords, key)
      endif
    endfor

    " set completion flag
    let b:radiossUserComp = 1
    " return list after completion
    return compKeywords

  endif

endfunction

"-------------------------------------------------------------------------------

function! radioss_library#GetCompletion()

  "-----------------------------------------------------------------------------
  " Function to take keyword name from current line and insert keyword
  " definition from the library.
  "
  " Arguments:
  " - None
  " Return:
  " - None
  "-----------------------------------------------------------------------------

  " save unnamed register
  let tmpUnnamedReg = @@

  " get keyword from current line
  if getline('.')[0] == "/"
    let keyword = tolower(getline('.')[1:])
  else
    let keyword = tolower(getline('.')[0:])
  endif

  " substitute / -> _ (but not if it starts with '_')
  "let keyword = substitute(keyword, "/", "_", "g")
  if keyword != "_"
    let keyword = substitute(keyword, "/", "_", "g")
  endif

  " extract sub directory name from keyword name
  if keyword =~? "^/"
    let KeyLibSubDir = keyword[1] . '/'
  else
    let KeyLibSubDir = keyword[0] . '/'
  endif

  " set keyword file path
  let file = g:radiossKeyLibPath . KeyLibSubDir . keyword . ".rad"
  echom file

  " check if the file exist and put it
  if filereadable(file)
   execute "read " . file
   normal! kdd
   " jump to ID field after keyword
   call search("?")
  else
    normal! <C-Y>
  endif

  " restore unnamed register
  let @@ = tmpUnnamedReg

  " reset completion flag
  let b:radiossUserComp = 0

endfunction

"-------------------------------------EOF---------------------------------------
