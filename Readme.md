# 使い方
```bash
$ git clone git://github.com/tune/dotfiles.git
$ cd dotfiles
$ git submodule init
$ git submodule update
$ ./setup.sh
$ ./gem_setup.rb
```

vimを起動する前にNeoBundleをインストールしておく。
```bash
$ git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
```
vimを起動したら`:NeoBundleInstall`を実行する。

最後にvimprocのmakeをして終了。
```bash
$ cd ~/.vim/bundle/vimproc/
$ make -f make_XXX.mak # XXXは実行環境によって適宜読み替え
```


# 設定ファイル

* .inputrc
* .irbrc
* git
    * .gitconfig
    * .global_ignore
* .screenrc
* .tmux.conf
* vim
    * .vimrc
    * .gvimrc
* zsh
    * .zshenv
    * .zshrc

# ツールの入手先

* [Ricty](https://github.com/yascentur/Ricty) : font
* [the_silver_searcher](https://github.com/ggreer/the_silver_searcher)

