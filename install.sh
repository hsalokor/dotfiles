#!/bin/bash

git submodule init
git submodule update

# Install ghc-mod
cabal update
cabal install ghc-mod

if [ -e ~/.vimrc ]
then
    mv ~/.vimrc ~/.vimrc.bak
fi
cp -rf vim/_vimrc ~/.vimrc

if [ -e ~/.gvimrc ]
then
    mv ~/.gvimrc ~/.gvimrc.bak
fi
cp -rf vim/_gvimrc ~/.gvimrc

if [ -e ~/.vim ]
then
    rm -rf ~/.vim.bak
    mv ~/.vim ~/.vim.bak
fi

mkdir -p ~/.vim
rm -rf ~/.vim/bundle/*
cp -rf vim/_vim/* ~/.vim/

# Copy scripts to bin
mkdir -p ~/bin/
cp -rf bin/* ~/bin/

# Install vim bundles
vim +BundleInstall +qall

# Compile vimproc
pushd ~/.vim/bundle/vimproc/
make -f make_unix.mak
make -f make_mac.mak
popd

cp -rf tmux.conf ~/.tmux.conf
