#!/bin/bash

# Create symbolic link
DOT_FILES=(
	.gitconfig
	.irbrc
	.screenrc
	.vimrc
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
    echo "###########################################################" >> .global_ignore
    echo "# From $file" >> .global_ignore
    cat "git/gitignore/$file" >> .global_ignore
    echo $'\n' >> .global_ignore
done
