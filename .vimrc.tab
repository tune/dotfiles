" tab設定
" http://blog.remora.cx/2012/09/use-tabpage.html

" tab移動をShift+Tabでできるようにする
nnoremap <S-Tab> gt
nnoremap <Tab><Tab> gT
for i in range(1, 9)
  execute 'nnoremap <Tab>' . i . ' ' . i . 'gt'
endfor


set tabline=%!MyTabLine()

function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999XClose'
  endif

  return s
endfunction

let g:use_Powerline_dividers = 1

function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let altbuf = bufname(buflist[winnr - 1])

  " $HOME を消す
  let altbuf = substitute(altbuf, expand('$HOME/'), '', '')

  " カレントタブ以外はパスを短くする
  if tabpagenr() != a:n
    let altbuf = substitute(altbuf, '^.*/', '', '')
    let altbuf = substitute(altbuf, '^.\zs.*\ze\.[^.]\+$', '', '')
  endif

  " vim-powerline のグリフを使う
  if g:use_Powerline_dividers
    let dividers = g:Pl#Parser#Symbols[g:Powerline_symbols].dividers
    let left_div = nr2char(get(dividers[3], 0, 124))
    let right_div = nr2char(get(dividers[1], 0, 124))
    let altbuf = left_div . altbuf . right_div
  else
    let altbuf = '|' . altbuf . '|'
  endif

  " タブ番号を付加
  let altbuf = a:n . ':' . altbuf

  return altbuf
endfunction

