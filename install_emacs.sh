#!/bin/sh

# Setup emacs.d
if [ -e ~/.emacs.d ]
then
    rm -rf ~/.emacs.d
fi
mkdir -p ~/.emacs.d
mkdir -p ~/.emacs.d/dict
mkdir -p ~/.emacs.d/elpa
cp -rf emacs/* ~/.emacs.d/

