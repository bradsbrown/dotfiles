# uncomment the below line to let zprof inspect startup
# zmodload zsh/zprof

# Only check compinit cache once a day
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
    compinit
done

compinit -C

# If you come from bash you might have to change your $PATH.
export PATH=/usr/local/bin:$PATH:${HOME}/.local/bin:${HOME}/.emacs.d/bin:${HOME}/go/bin
export DISABLE_AUTO_TITLE='true'
export PYTHONDONTWRITEBYTECODE=1
export GPG_TTY=$(tty)
#
export ZSH_TMUX_ITERM2=true
export TERM=xterm-256color
# [ -n "$TMUX" ] && export TERM=screen-256color

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

source ~/.aliases
source ~/.profile

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="lambda-pure"
# autoload -U promptinit; promptinit
# prompt lambda-pure

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder


# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
if [[ ! -f ~/.zpm/zpm.zsh ]]; then
    git clone --recursive https://github.com/zpm-zsh/zpm ~/.zpm
fi
fpath+=~/.zfunc
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
plugins=(
    git
    git-extras
    github
    httpie
    osx
    pip
    pyenv
    python
    tmux
    zsh-vi-mode
    z
    # Custom Plugins
    zsh-vi-mode
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-peco-history
    evalcache
)

source $ZSH/oh-my-zsh.sh

# pyenv-virtualenvwrapper
export PYENV_VIRTUALENVWRAPPER_PREFER_PYENV="true"
export WORKON_HOME=$HOME/.virtualenvs
pyenv virtualenvwrapper_lazy

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"
export ZSH_PECO_HISTORY_DEDUP=1
function zvm_after_lazy_keybindings() {
    zvm_bindkey main '^R' peco_select_history
    zvm_bindkey viins '^R' peco_select_history
    zvm_bindkey vicmd '^R' peco_select_history
    zvm_bindkey viopp '^R' peco_select_history
    zvm_bindkey visual '^R' peco_select_history
}

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set up autocompletions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
_evalcache direnv hook zsh
eval "$(_TMUXP_COMPLETE=source_zsh tmuxp)"

_evalcache thefuck --alias

show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "($(basename $VIRTUAL_ENV))"
  fi
}
PS1='$(show_virtual_env)'$PS1
_evalcache starship init zsh
