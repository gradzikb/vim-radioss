"-------------------------------------BOF---------------------------------------
"
" Vim filetype plugin file
"
" Language:     VIM Script
" Filetype:     Radioss FE solver input file
" Maintainer:   Bartosz Gradzik <bartosz.gradzik@hotmail.com>
" Last Change:  8th of March 2015
"
"-------------------------------------------------------------------------------

function! radioss_autoformat#RadiossLine() range

  "-----------------------------------------------------------------------------
  " Function to autformat Ls-Dyna line.
  "
  " Arguments:
  " - None
  " Return:
  " - None
  "-----------------------------------------------------------------------------

  " find keyword
  call search('^/\a','b')
  let keyword = getline('.')

  "-----------------------------------------------------------------------------
  if keyword =~? '/FUNCT'

    " get all lines with points
    let points = []
    for i in range(a:firstline, a:lastline)
      let points = points + split(getline(i), '\s*,\s*\|\s\+')
    endfor

    " remove old lines
    execute a:firstline . "," . a:lastline . "delete"
    normal! k

    " save new lines
    for i in range(0, len(points)-1, 2)
      let newLine = printf("%20s%20s", points[i], points[i+1])
      normal! o
      call setline(".", newLine)
    endfor

    call cursor(a:firstline+1, 0)

  else

    for i in range(a:firstline, a:lastline)
      let line = split(getline(i))
      for j in range(len(line))
        let fStr = "%10s"
        if line[j] =~# ","
          if len(line[j]) !=# 1
            let fStr = "%" . line[j][:-2] . "0s"
          endif
          let line[j] = printf(fStr, "")
        else
          let line[j] = printf(fStr, line[j])
        endif
      endfor
      call setline(i, join(line, ""))
    endfor
    call cursor(a:lastline+1, 0)

  endif
endfunction

"-------------------------------------EOF---------------------------------------
