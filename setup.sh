#!/bin/bash

echo "Brad's Auto Setup: preparing to set up your Mac..."

# check for brew, install if not
echo "Checking for homebrew..."
command -v brew >/dev/null 2>&1 || {echo "Brew not installed, installing now..." >&2; /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";}

# add all brew requirements
echo "brew installing all required modules..."
cat requirements.txt | while read LINE
do
    brew install $LINE
done

# setup vim
echo "Installing Plug for vim..."
if ! [-e ~/.vim/autoload/plug.vim]
then
    cd ~/.vim/autoload
    git clone https://gitub.com/junegunn/vim-plug.git
fi

# Move old Bash Profile and vimrc, create link to new ones
echo "Moving old bash profile and vimrc, symlinking dotfiles versions..."
if [-e ~/.bash_profile]
then
    mv ~/.bash_profile ~/.bash_profile_old
fi
if [-e ~/.vimrc]
then
    mv ~/.vimrc ~/.vimrc_old
fi
ln -s ~/dotfiles/bash_profile ~/.bash_profile
ln -s ~/dotfiles/vimrc ~/.vimrc

echo "All set, Enjoy your mac!"
