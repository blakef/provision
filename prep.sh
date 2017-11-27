#!/bin/bash

# Update System & commandline tools 
softwareupdate -ia

# Xcode
sudo xcodebuild -license

# Pip
sudo easy_install pip

# Git
FULLNAME=`id -F`
read -p "(git config) What is your full name sailor (default: $FULLNAME)? " TMP_NAME 
read -p "(git config) What email address do you go by on GitHub/Lab/Work? " EMAIL
echo

FULLNAME=${TMP_NAME:-$FULLNAME}
if [ "$HOME" -ne "$(pwd)" ]; then
    cat .gitconfig > "$HOME/.gitconfig"
else
    echo "[user]" >> "$HOME/.gitconfig"
fi
echo -e "\tname = $FULLNAME\n\temail = $EMAIL" >> "$HOME/.gitconfig"

# SSH RSA Key
if [ ! -e "$HOME/.ssh/id_rsa" ]; then
    HOST=$(ipconfig getpacket en0 | grep 'domain_name (string)' | awk '{ print $3 }')
    ssh-keygen -t rsa -C "$(whoami)@$HOST" -q -N "" -f ~/.ssh/id_rsa
fi

# Brew
TRAVIS=true /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Common Applications
brew install cmake coreutils python3
brew install vim --override-system-vi
brew install gnu-sed --with-default-names
brew tap caskroom/cask
brew cask install \
    google-chrome \
    sublime-text \
    iterm2 \
    spotify \
    hipchat \
    slack \
    shiftit \
    macvim \
    git \
    nvim \
    caskroom/versions/firefoxdeveloperedition 

# Git Niceness on bash prompt
touch ~/.bash_profile

cat >> ~/.bash_profile <<EOF
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
EOF

# NVM and Node
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

# Git auto-completion 
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
echo "test -f ~/.git-completion.bash && . ~/.git-completion.bash" >> .bash_profile
    
# NVIM
pip3 install neovim
cp -r .config ~/
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +qall

# VIM config
mkdir -p ~/.vim/bundle && \
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle && \
    git clone https://github.com/blakef/vim-config ~/.vim-config && \
    ln -s ~/.vim-config/.vimrc ~/.vimrc && \
    vim +PluginInstall +qall && \
    ( cd ~/.vim/bundle/YouCompleteMe; python install.py --clang-completer --tern-completer --gocode-completer)

sed -i'' 's/wombat256mod/wombat256/' ~/.vim/bundle/wombat256/colors/wombat256.vim
