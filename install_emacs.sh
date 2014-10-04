#!/bin/sh

# Setup emacs.d
if [ -e ~/.emacs.d ]
then
    rm -rf ~/.emacs.d
fi
mkdir -p ~/.emacs.d
mkdir -p ~/.emacs.d/dict
mkdir -p ~/.emacs.d/elpa

rsync -av --progress emacs/ ~/.emacs.d/ --exclude clang-autocomplete

if [ $(which llvm-config) != "" ]
then
    pushd emacs/clang-autocomplete/
    make || exit 1
    popd
    cp emacs/clang-autocomplete/clang-complete ~/.emacs.d/
else
    echo "LLVM config not found - not compiling clang-complete"
fi


