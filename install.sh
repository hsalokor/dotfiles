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
rm -rf ~/.vim/bundle/*
cp -rf vim/_vim/* ~/.vim/

cp -rf tmux.conf ~/.tmux.conf
