export GOPATH=$HOME/golang
export EDITOR=vim
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

bind "set completion-ignore-case on"

test -r /sw/bin/init.sh && . /sw/bin/init.sh

# Setting PATH for Python 3.5
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}:${HOME}/.local/bin"
export PATH

# colors!
green="\[\033[0;32m\]"
blue="\[\033[0;34m\]"
purple="\[\033[0;35m\]"
reset="\[\033[0m\]"


# use .aliases
source $HOME/.aliases

# use .profile
source $HOME/.profile


# Bash Scripting
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi
for script in $(brew --prefix)/etc/profile.d/*.sh
do
    if [ -r $script ]; then
        . $script
    fi
done
if [ -f ~/.bashrc ]
then
    . ~/.bashrc;
fi

# pyenv
eval "$(pyenv init -)"
export PYENV_VIRTUALENVWRAPPER_PREFER_PYENV="true"
export WORKON_HOME=$HOME/.virtualenvs
pyenv virtualenvwrapper

function clmutt {
    host=muttdirect
    case "$1" in
        --vpn|-v)
            host=muttvpn
        ;;
        --local|-l)
        ;;
        *)
            /opt/cisco/anyconnect/bin/vpn state | grep -lq Connected
            exitcode=$?
            if [ $exitcode -eq 0 ]; then
                host=muttvpn
            fi
        ;;
    esac
    echo using host $host
    ssh bradsbrown@${host} -t mutt
}

# theFuck Activation
eval "$(thefuck --alias)"

# A little Python-ism to start your session
python -m this | tail -n +3 | sort -R | head -1

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
