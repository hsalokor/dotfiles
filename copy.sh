#!/bin/sh
rm -rf vim
mkdir -p vim
cp -rf ~/.vimrc vim/_vimrc
cp -rf ~/.gvimrc vim/_gvimrc
cp -rf ~/.vim vim/_vim

rm -rf xmonad
mkdir -p xmonad
cp -rf ~/.xmonad/xmonad.hs xmonad/xmonad.hs

cp -rf ~/.tmux.conf tmux.conf
