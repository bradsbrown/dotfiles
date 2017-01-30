export EDITOR=vim
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
bind "set completion-ignore-case on"

test -r /sw/bin/init.sh && . /sw/bin/init.sh

# Setting PATH for Python 3.5
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"
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
alias ,gsl='git stash list'
alias ,gsp='git stash pop'
alias ,gpp='git log --oneline --graph --color --all --decorate'

# Work-specific Aliases
alias .rba='cd ~/Development/rba/rba_roast'

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

# AutoEnv Activation
source /usr/local/opt/autoenv/activate.sh
