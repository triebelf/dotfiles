#!/bin/sh -eu
for i in * ; do echo $i ; cp -f ~/.dotfiles/alacritty_tmp.yml ~/.dotfiles/alacritty.yml; sed -i -e "/COLOR/r $i" ~/.dotfiles/alacritty.yml ; read ; done
