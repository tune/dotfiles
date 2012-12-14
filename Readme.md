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


# 設定ファイル

* .inputrc
* .irbrc
* git
    * .gitconfig
    * .global_ignore
* .pryrc
* .screenrc
* .tigrc
* .tmux.conf
* vim
    * .vimrc
    * .gvimrc
* zsh
    * .zshenv
    * .zshrc

# ツールの入手先

* font
	* [Ricty](https://github.com/yascentur/Ricty) 
* git
	* [git-extras](https://github.com/visionmedia/git-extras)
	* [legit](http://www.git-legit.org/)
* zsh
	* [autojump](https://github.com/joelthelion/autojump)
* Utility
	* [the_silver_searcher](https://github.com/ggreer/the_silver_searcher)

