#!/bin/sh
if [ -e ~/.vimrc ]
then
    cp ~/.vimrc ~/.vimrc.bak
    cp -rf vim/_vimrc ~/.vimrc
fi

if [ -e ~/.vim ]
then
    rm -rf ~/.vim.bak
    cp -rf ~/.vim ~/.vim.bak
fi
cp -rf vim/_vim ~/.vim

