#!/bin/sh
if [ -e ~/.vimrc ]
then
    cp ~/.vimrc ~/.vimrc.bak
fi
cp -rf vim/_vimrc ~/.vimrc

if [ -e ~/.gvimrc ]
then
    cp ~/.gvimrc ~/.gvimrc.bak
fi
cp -rf vim/_gvimrc ~/.gvimrc

if [ -e ~/.vim ]
then
    rm -rf ~/.vim.bak
    cp -rf ~/.vim ~/.vim.bak
fi
mkdir -p ~/.vim
cp -rf vim/_vim/* ~/.vim/

