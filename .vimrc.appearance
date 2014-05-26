"--------------------------------------------------------------------
" 表示関連
"
" シンタックスハイライトを有効にする
if has("syntax")
  syntax on
endif

" メッセージ表示欄を2行確保
set cmdheight=2

" 行番号表示
set number

" 自動インデント
set autoindent
set smartindent

" タブ幅を設定する
set cindent
set tabstop=4
set shiftwidth=4
autocmd FileType apache     setlocal sw=4 sts=4 ts=4
autocmd FileType c          setlocal sw=4 sts=4 ts=4
autocmd FileType cpp        setlocal sw=4 sts=4 ts=4
autocmd FileType cs         setlocal sw=4 sts=4 ts=4
autocmd FileType css        setlocal sw=2 sts=2 ts=2
autocmd FileType diff       setlocal sw=4 sts=4 ts=4
autocmd FileType eruby      setlocal sw=4 sts=4 ts=4
autocmd FileType html       setlocal sw=2 sts=2 ts=2
autocmd FileType java       setlocal sw=4 sts=4 ts=4
autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et
autocmd FileType perl       setlocal sw=4 sts=4 ts=4
autocmd FileType php        setlocal sw=4 sts=4 ts=4
autocmd FileType python     setlocal sw=4 sts=4 ts=4
autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
autocmd FileType haml       setlocal sw=2 sts=2 ts=2
autocmd FileType sh         setlocal sw=4 sts=4 ts=4
autocmd FileType sql        setlocal sw=4 sts=4 ts=4
autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
autocmd FileType xhtml      setlocal sw=4 sts=4 ts=4
autocmd FileType xml        setlocal sw=4 sts=4 ts=4
autocmd FileType yaml       setlocal sw=2 sts=2 ts=2
autocmd FileType zsh        setlocal sw=4 sts=4 ts=4
autocmd FileType scala      setlocal sw=2 sts=2 ts=2

" 不可視文字表示
set list

" 不可視文字の表示形式
set listchars=tab:>.,trail:_,extends:>,precedes:<

" 印字不可能文字を16進数で表示
set display=uhex

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

"入力中のコマンドをステータスに表示する
set showcmd

"括弧入力時の対応する括弧を表示
set showmatch

"検索結果文字列のハイライトを有効にする
set hlsearch

"ステータスラインを常に表示
set laststatus=2

"ステータスラインに文字コードと改行文字を表示する
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

" 色設定
colorscheme molokai
let g:molokai_original = 1
set background=dark

" 自動改行しない
set textwidth=0

" UTF-8における矢印・記号の幅をwide characterにする
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" フォント
set gfn=Ricty:h18

" 行末の空白をハイライトする
" http://d.hatena.ne.jp/kasahi/20070902/1188744907
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
autocmd WinEnter * match WhitespaceEOL /\s\+$/

" カーソル行をハイライト
set cursorline
" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine term=reverse cterm=reverse

" Markdown編集中はイタリックフォントを使わない
" http://qiita.com/items/58a68e4981c52b1872ad
autocmd! FileType markdown hi! def link markdownItalic LineNr

" Markdown内部を色づけ
let g:markdown_fenced_languages = [
  \  'coffee',
  \  'css',
  \  'javascript',
  \  'js=javascript',
  \  'json=javascript',
  \  'ruby',
  \  'sass',
  \  'xml',
  \]

" コマンド実行中は再描画しない
set lazyredraw

" 高速ターミナル接続を行う
set ttyfast

" cygwin/mintty ターミナル上の vim で、モードに応じてカーソル形状を変える
if has("win32unix")
  let &t_ti.="\e[1 q"
  let &t_SI.="\e[5 q"
  let &t_EI.="\e[1 q"
  let &t_te.="\e[0 q"
endif

