#!/bin/sh

# Setup emacs.d
if [ -e ~/.emacs.d ]
then
    rm -rf ~/.emacs.d
fi
mkdir -p ~/.emacs.d
cp -rf emacs/* ~/.emacs.d/

