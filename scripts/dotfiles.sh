#!/bin/sh
git clone "--separate-git-dir=$HOME/.dotfiles" https://github.com/$1/dotfiles $HOME/dotfiles-tmp
cp ~/dotfiles-tmp/. ~ -r
echo 'gitdir: .dotfiles/.dotfiles' > ~/.git
rm ~/dotfiles-tmp -r
