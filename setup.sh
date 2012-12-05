#!/bin/bash

# Create symbolic link
DOT_FILES=(
    .gitconfig
    .gvimrc
    .inputrc
    .irbrc
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


# Create .global_ignore for git
IGNORE_FILES=(
    Autotools.gitignore
    C++.gitignore
    C.gitignore
    Ruby.gitignore
    Global/Linux.gitignore
    Global/SVN.gitignore
    Global/VisualStudio.gitignore
    Global/Windows.gitignore
    Global/vim.gitignore
)

for file in ${IGNORE_FILES[@]}
do
    GLOBAL_IGNORE_FILE=$HOME/.global_ignore
    
    echo "###########################################################" >> $GLOBAL_IGNORE_FILE
    echo "# From $file" >> $GLOBAL_IGNORE_FILE
    cat "$HOME/dotfiles/git/gitignore/$file" >> $GLOBAL_IGNORE_FILE
    echo $'\n' >> $GLOBAL_IGNORE_FILE
done
