#!/bin/bash

DEPEND="
vim 
git
build-essential
zsh
libx11-dev
libxft-dev
libxinerama-dev
libx11-xcb-dev
libxcb-res0-dev
apt-transport-https
curl
gnupg
neovim
mpv
"

sudo apt update

sudo apt install $DEPEND -y


#curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -

#echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

#sudo apt install brave-browser

#TODO: check to see if brave key is in keyring and if repo is in sources.list

