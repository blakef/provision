#!/bin/bash

# Update System & commandline tools 
softwareupdate -ia

# Xcode
sudo xcodebuild -license

# Pip
sudo easy_install pip

# SSH RSA Key
if [ ! -e "$HOME/.ssh/id_rsa" ]; then
    HOST=$(ipconfig getpacket en0 | grep 'domain_name (string)' | awk '{ print $3 }')
    ssh-keygen -t rsa -C "$(whoami)@$HOST" -q -N "" -f ~/.ssh/id_rsa
fi

# Brew
TRAVIS=true /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Common Applications
brew install vim cmake
brew tap caskroom/cask
brew cask install \
    google-chrome \
    sublime-text \
    iterm2 \
    macvim \
    spotify \
    hipchat \
    caskroom/versions/firefoxdeveloperedition 

# NVM and Node
touch ~/.bash_profile
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash
source ~/.bash_profile

nvm install node
nvm alias default $(nvm current)

# Node Packages
npm i -g yarn
yarn add -g commitizen cz-conventional-changelog eslint typescript

# Enable remote ssh login
sudo systemsetup -setremotelogin on
sudo dseditgroup -o create -q com.apple.access_ssh
sudo dseditgroup -o edit -a admin -t group com.apple.access_ssh

# VIM config
mkdir -p ~/.vim/bundle && \
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle && \
    git clone https://github.com/blakef/vim-config ~/.vim-config && \
    ln -s ~/.vim-config/.vimrc ~/.vimrc && \
    vim +PluginInstall +qall && \
    ( cd ~/.vim/bundle/YouCompleteMe; python install.py --clang-completer --tern-completer)

