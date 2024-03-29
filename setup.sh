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

# set up pipx
command -v pipx
exit_code=$?
if [ "$exit_code" -ne "0" ]; then
    python3 -m pip install --user pipx
fi

while read in; do pipx install "$in"; done <pipx.text

if ! [ -d "${HOME}/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# setup vim
echo "Checking for vim-plug..."
if ! [ -e ~/.vim/autoload/plug.vim ]; then
    echo "vim-plug not found. Installing..."
    PLUGINSTALL=true
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

function makeLink() {
    current_dir=$1
    shift
    source_file=$1
    shift
    target_dir=$1
    target_file="$source_file"
    if shift; then
        target_file=$1
    fi
    ln -s "${current_dir}/${source_file}" "${target_dir}/${target_file}"
}

function checkLink() {
    current_dir=$(pwd)
    source_file=$1
    shift
    target_dir=$1
    file_prepend=""
    if [ "$1" = "--dotted" ]; then
        file_prepend="."
    fi
    source_path="${current_dir}/${source_file}"
    target_path="${target_dir}/${file_prepend}${source_file}"
    if [ -e  "$target_path" ]; then
        if ! [ -L "$target_path" ]; then
            unlink "$target_path"
        else
            mv "$target_path" "${target_path}_old"
        fi
    fi
    makeLink "$current_dir" "$source_file" "$target_dir" "${file_prepend}${source_file}"
}

# Move old Bash and Vim setting files, create link to new ones
echo "Moving old Bash and Vim setting files, symlinking dotfiles versions..."
checkLink bash_profile "$HOME" --dotted
checkLink bashrc "$HOME" --dotted
checkLink profile "$HOME" --dotted
checkLink aliases "$HOME" --dotted
checkLink vimrc "$HOME" --dotted
checkLink colorsh.sh /usr/local/etc/profile.d
checkLink tmux.conf "$HOME" --dotted
checkLink gitconfig "$HOME" --dotted
checkLink gitignore "$HOME" --dotted
checkLink gitattributes "$HOME" --dotted
checkLink zshrc "$HOME" --dotted

vim_dir="${HOME}/.vim"
nvim_dir="${HOME}/.config/nvim"
mkdir -p "$vim_dir"
mkdir -p "$nvim_dir"
checkLink coc-settings.json "$vim_dir"
checkLink coc-settings.json "$nvim_dir"
checkLink init.vim "$nvim_dir"

# Add zenburn color scheme to vim colors
if ! [ -e ~/.vim/colors  ]; then
    mkdir ~/.vim/colors
fi
for x in $(ls colors); do
    name=${x##*/}
    if ! [ -e "$HOME/.vim/colors/$name" ]; then
        ln -s "$HOME/dotfiles/colors/${name}" "$HOME/.vim/colors/${name}"
    fi
done

# Run PlugInstall if necessary
if [ "$PLUGINSTALL" == true ]; then
    echo "Plug was installed, do you want to run PlugInstall to setup your plugins now?"
    read -p "y/n: " DOINSTALL
    if [ "$DOINSTALL" == 'y' ]; then
        echo "You will now be taken to vim. You can quit with ':q' when done."
        sleep 3
        vim -c "PlugInstall"
    fi
fi

echo "All set, Enjoy your mac!"
