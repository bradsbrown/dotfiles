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

# Terminal Aliases
alias ls="ls -FGh"
alias ll="ls -l"
alias l="ls"
alias la="ls -la"
alias su="su -"
alias ssjqe="ssh 10.15.194.15"
alias ssjqn="ssh 10.15.194.74"

# Git Aliases
alias ,b='git branch'
alias ,s='git status'
alias ,a='git add'
alias ,c='git commit'
alias ,cc='git commit'
alias ,ca='git commit -a'
alias ,ch='git checkout'
alias ,pso='git push origin'
alias ,psu='git push upstream'
alias ,plum='git pull upstream master'
alias ,plom='git pull origin master'
alias ,gsl='git stash list'
alias ,gsp='git stash pop'
alias ,gpp='git log --oneline --graph --color --all --decorate'
alias ,gsu='cd ~/Development && git standup -m 3'

# Work-specific Aliases
alias .rba='cd ~/Development/rba/rba_roast'
alias .jjb='rm -rf ~/jjb && ./build-jobs.sh --test -o ~/jjb && ./build-jobs.sh --cluster --test -o ~/jjb'

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

# branch searcher
function ,tobranch() {
    git branch | sed -n -e 's/^.* //' -e /"$1"/p | xargs -n 1 git checkout
}

# pyenv
eval "$(pyenv init -)"
export PYENV_VIRTUALENVWRAPPER_PREFER_PYENV="true"
export WORKON_HOME=$HOME/.virtualenvs
pyenv virtualenvwrapper

function clmutt {
    host=muttdirect
    /opt/cisco/anyconnect/bin/vpn state | grep -lq Connected
    exitcode=$?
    if [ $exitcode -eq 0 ]; then
        host=muttvpn
    fi
    echo using host $host
    ssh bradsbrown@${host} -t mutt
}

# theFuck Activation
eval "$(thefuck --alias)"

# A little Python-ism to start your session
python -m this | tail -n +3 | sort -R | head -1
