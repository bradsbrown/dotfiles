#!/bin/bash

echo "Brad's Auto Setup: preparing to set up your Mac..."

# check for brew, install if not
echo "Checking for homebrew..."
command -v brew >/dev/null 2>&1 || {/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"}

# add all brew requirements
echo "brew installing all required modules..."
cat requirements.txt | while read LINE
do
    if ! brew ls --versions $LINE > /dev/null; then
        brew install $LINE
    fi
done

# setup vim
echo "Checking for vim-plug..."
if ! [ -e ~/.vim/autoload/plug.vim ]; then
    echo "vim-plug not found. Installing..."
    PLUGINSTALL=true
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Move old Bash and Vim setting files, create link to new ones
echo "Moving old Bash and Vim setting files, symlinking dotfiles versions..."
bashprof=~/.bash_profile
if ! [ -s $bashprof ]; then
    if [ -e $bashprof ]; then
        mv $bashprof ${bashprof}_old
    fi
    ln -s ~/dotfiles/bash_profile $bashprof
fi
bashrc=~/.bashrc
if ! [ -s $bashrc ]; then
    if [ -e $bashrc ]; then
        mv $bashrc ${bashrc}_old
    fi
    ln -s ~/dotfiles/bashrc $bashrc
fi
vimrc=~/.vimrc
if ! [ -s $vimrc ]; then
    if [ -e $vimrc ]; then
        mv $vimrc ${vimrc}_old
    fi
    ln -s ~/dotfiles/vimrc $vimrc
fi
colorsh=/usr/local/etc/profile.d/colorsh.sh
if ! [ -s $colorsh ]; then
    if [ -e $colorsh ]; then
        mv $colorsh ${colorsh}_old
    fi
    ln -s ~/dotfiles/colorsh.sh $colorsh
fi
tmux=~/.tmux.conf
if ! [ -s $tmux ]; then
    if [ -e $tmux ]; then
        mv $tmux ${tmux}_old
    fi
    ln -s ~/dotfiles/tmux.conf $tmux
fi

# Add zenburn color scheme to vim colors
if ! [ -e ~/.vim/colors  ]; then
    mkdir ~/.vim/colors
fi
if ! [ -e ~/.vim/colors/zenburn.vim ]; then
    ln -s ~/dotfiles/zenburn.vim ~/.vim/colors/zenburn.vim
fi

# Run PlugInstall if necessary
if [ "$PLUGINSTALL" == true ]; then
    echo "Plug was installed, do you want to run PlugInstall to setup your plugins now?"
    read -p "y/n: " DOINSTALL
    if [ $DOINSTALL == 'y' ]; then
        echo "You will now be taken to vim. You can quit with ':q' when done."
        sleep 3
        vim -c "PlugInstall"
    fi
fi

echo "All set, Enjoy your mac!"
