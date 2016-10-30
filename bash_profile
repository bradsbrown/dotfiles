export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
bind "set completion-ignore-case on"

test -r /sw/bin/init.sh && . /sw/bin/init.sh

# Setting PATH for Python 3.5
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"
export PATH

# Enable tab completion
source ~/git-completion.bash

# colors!
green="\[\033[0;32m\]"
blue="\[\033[0;34m\]"
purple="\[\033[0;35m\]"
reset="\[\033[0m\]"

# Change command prompt
source ~/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
# '\u' adds the name of the current user to the prompt
# '\$(__git_ps1)' adds git-related stuff
# '\W' adds the name of the current directory
export PS1="$purple\u$green\$(__git_ps1)$blue \W $ $reset"

# Useful Aliases
alias ,b='git branch'
alias ,s='git status'
alias ,a='git add'
alias ,c='git commit'
alias ,ca='git commit -a'
alias ,po='git push origin'
alias ,pu='git push upstream'
