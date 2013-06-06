" やはりWindowsのキーバインディングからは抜け出せない orz
:source $VIMRUNTIME/mswin.vim

" Hack #234: Vim外にいるときはVimを透けさせる
" http://vim-users.jp/2011/10/hack234/
augroup hack234
  autocmd!
  if has('mac')
    autocmd FocusGained * set transparency=10
    autocmd FocusLost * set transparency=50
  endif
augroup END

" Ricty
set guifont=Ricty\ 12

