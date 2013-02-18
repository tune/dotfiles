#!/bin/bash

# Create symbolic link
DOT_FILES=(
    .gitconfig
    .gvimrc
    .inputrc
    .minttyrc
    .pryrc
    .screenrc
    .tigrc
    .tmux.conf
    .vimrc
    .zshenv
    .zshrc
)

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/dotfiles/$file $HOME/$file
done

# refresh path setting
source ~/.zshenv
source ~/.zshrc

# Create .global_ignore for git
gibo -u
gibo Autotools C++ C Ruby Linux SVN VisualStudio Windows vim >> ~/.global_ignore

