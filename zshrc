# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/r0mai/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# to install this: git clone https://github.com/Powerlevel9k/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
ZSH_THEME="powerlevel9k/powerlevel9k"

# Installed this https://github.com/ryanoasis/nerd-fonts
# and selected the nerd font in preferences
POWERLEVEL9K_MODE='nerdfont-complete'

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
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

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

# powerlevel9k theme customization
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history time)

function is_osx() {
    if test "$(uname)" = "Darwin"; then
         return 0
    fi
    return 1
}

if is_osx; then
    export PATH="/Applications/MacVim.app/Contents/bin:${PATH}"
fi

#git repo location
export DOTFILES_REPO=~/dotfiles

function extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.lz) tar xvf "$1" ;;
            *.tar.bz2) tar xvjf "$1" ;;
            *.tar.gz) tar xvzf "$1" ;;
            *.tar.xz) tar xvJf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xvf "$1" ;;
            *.tbz2) tar xvjf "$1" ;;
            *.tgz) tar xvzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.apk) unzip "$1" ;;
            *.aar) unzip "$1" ;;
            *.jar) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "'$1' cannot be extracted via >extract<"
               return 1 ;;
        esac
    else
        echo "'$1' is not a valid file!"
        return 1
    fi
}

function mkcd() {
    mkdir -p -- "$1" && cd -P -- "$1"
}

function adb_paste() {
    adb shell input keyboard text "$(echo "$@" | sed 's/ /\\ /g' | sed 's/&/\\&/g')"
}

function format_xml() {
    if [ $# -ne 1 ]; then
        echo "Usage: xml_format <xml>"
        return 1
    fi

    xmllint --format "$1" > "$1.tmp" && mv "$1.tmp" "$1"
}

# setup python for
# https://github.com/martong/ycm_extra_conf.jsondb
export PYTHONPATH="${DOTFILES_REPO}/ycm_extra_conf.jsondb:${PYTHONPATH}"

#swap file location for vim
mkdir -p ~/.vim/swp

#vim
alias v='vim'

#sugoi
alias sd='sugoi-deps'
alias ss='sugoi-stash'
alias sv='sugoi-version'
alias st='sugoi-target'
alias sg='sugoi-gen'
alias sm='sugoi-make'
alias sp='sugoi-prefer'
alias rat='remake all tests'

# hub github.com/github/hub
if command -v hub > /dev/null 2>&1; then
    eval "$(hub alias -s)"
fi

if test -f ~/.bashrc_local; then
    source ~/.bashrc_local
fi
