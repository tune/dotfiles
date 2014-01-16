# 使い方
```bash
$ git clone --recursive https://github.com/tune/dotfiles.git
$ cd dotfiles
$ ./setup.sh
```

vimを起動する前にNeoBundleをインストールしておく。
```bash
$ git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
```
vimを起動したら`:NeoBundleInstall`を実行する。


# 設定ファイル

* git
    * .gitconfig
    * .global_ignore
* .inputrc
* .irbrc
* .minttyrc
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

## 固有の設定は下記の名称のローカルファイルを作ってそこに書く

* .gitconfig.local
* .vimrc.local
* .zshrc.local

gitのユーザ名、プロキシ設定は~/.gitconfig.localに記述すること。1.7.10以降のバージョンのgitが必要。


# ツールの入手先

* font
	* [Ricty](https://github.com/yascentur/Ricty) 
* git
	* [tig](http://jonas.nitro.dk/tig/)
	* [git-extras](https://github.com/visionmedia/git-extras)
	* [legit](http://www.git-legit.org/)
* zsh
	* [autojump](https://github.com/joelthelion/autojump)
* Utility
	* [GNU GLOBAL](http://savannah.gnu.org/projects/global/)
	* [jq](http://stedolan.github.io/jq/)
	* [Mosh: the mobile shell](http://mosh.mit.edu/)
	* [Pandoc](http://johnmacfarlane.net/pandoc/)
	* [the_silver_searcher](https://github.com/ggreer/the_silver_searcher)

