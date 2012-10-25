# 使い方
```bash
$ git clone git://github.com/tune/dotfiles.git
$ cd dotfiles
$ git submodule init
$ git submodule update
$ ./setup.sh
```

vimを起動する前にVundleをインストールしておく。
```bash
$ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
```

vimを起動したら`:BundleInstall`を実行する。


# 設定ファイル

* .inputrc
* .irbrc
* git
    * .gitconfig
    * .global_ignore
* .screenrc
* .vimrc
* zsh
    * .zshenv
    * .zshrc
