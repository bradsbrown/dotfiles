#!/bin/bash

echo "Brad's Auto Setup: preparing to set up your Mac..."

# check for brew, install if not
echo "Checking for homebrew..."
Command -v brew
exit_code=$?
if [ "$exit_code" -ne "0" ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# add all brew requirements
echo "brew installing all required modules..."
brew bundle

# set up pip
Command -v pip
exit_code=$?
if [ "$exit_code" -ne "0" ]; then
    sudo easy_install pip
    sudo pip install virtualenv
fi

# set up pipsi
Command -v pipsi
exit_code=$?
if [ "$exit_code" -ne "0" ]; then
    curl https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py | python
fi


# install pipenv
Command -v pipenv
exit_code=$?
if [ "$exit_code" -ne "0" ]; then
    pipsi install pipenv
fi


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
gitconfig==~/.gitconfig
if ! [ -s $gitconfig ]; then
    if [ -e $gitconfig ]; then
        mv $gitconfig ${gitconfig}_old
    fi
    ln -s ~/dotfiles/gitconfig $gitconfig
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
