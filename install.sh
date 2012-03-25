#!/bin/bash

git submodule init
git submodule update

# Install ghc-mod
cabal update
cabal install ghc-mod

# Install local Hoogle
cabal install hoogle
hoogle data

# Copy vim configs
cp -rf vim/_vimrc ~/.vimrc

cp -rf vim/_gvimrc ~/.gvimrc

# Setup vim directory
if [ -e ~/.vim ]
then
    rm -rf ~/.vim
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

# Compile command-t extension
pushd ~/.vim/bundle/command-t/ruby/command-t/
ruby extconf.rb
make
popd

# Copy tmux config
cp -rf tmux.conf ~/.tmux.conf
