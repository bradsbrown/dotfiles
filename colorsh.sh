# Beautiful prompt and prompt colors
C_BLACK="0;30m"
C_BLUE="0;34m"
C_GREEN="0;32m"
C_CYAN="0;36m"
C_RED="0;31m"
C_PURPLE="0;35m"
C_BROWN="0;33m"
C_LGRAY="0;37m"
C_DGRAY="1;30m"
C_LBLUE="1;34m"
C_LGREEN="1;32m"
C_LCYAN="1;36m"
C_LRED="1;31m"
C_LPURPLE="1;35m"
C_YELLOW="1;33m"
C_WHITE="1;37m"
# Different colors/options for certain users.
if [ ${UID} -eq 0 ]; then
# We're root
        P_PROMPT="# "
        P_C_NAME=$C_LRED
        P_C_HOST=$C_LRED
        P_C_CWD=$C_RED
        P_C_DEFAULT=$C_WHITE
else
# Normies get the placid colors. <3
        P_PROMPT="$ "
        P_C_NAME=$C_GREEN
        P_C_HOST=$C_GREEN
        P_C_CWD=$C_BLUE
        P_C_DEFAULT=$C_WHITE
fi
GIT_PS1_SHOWDIRTYSTATE=True
GIT_PS1_SHOWUNTRACKEDFILES=True
GIT_PS1_SHOWSTASHSTATE=True
PS1='\[\e[${P_C_DEFAULT}\][\
\[\e[${P_C_NAME}\]\u@\
\[\e[${P_C_HOST}\]\h \
\[\e[${P_C_CWD}\]\w\
\[\e[${P_C_DEFAULT}\]]\
\n\[\e[${C_PURPLE}\]$(__git_ps1 " (%s)")\[\e[${P_C_DEFAULT}\]\$ \
\[\e[m\]'
