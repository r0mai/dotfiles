# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="/Users/r0mai/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# to install this: https://github.com/romkatv/powerlevel10k#installation
ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=()

source $ZSH/oh-my-zsh.sh


# powerlevel9k theme customization
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir custom_sugoi_target vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true

function pl9k_sugoi_target_segment() {
    if test -e .sugoi.target; then
        sugoi target 2>&1 | cut -d' ' -f 2
    fi
}

POWERLEVEL9K_CUSTOM_SUGOI_TARGET="pl9k_sugoi_target_segment"
POWERLEVEL9K_CUSTOM_SUGOI_TARGET_BACKGROUND="178"

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
            *.pvl) unzip "$1" ;;
            *.pv) unzip "$1" ;;
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


function git-all() {
    local command="$@"
    if [ -z "$command" ]; then
        echo "Usage git-all <command>"
        return 1
    fi
    for d in $(find . -maxdepth 1 -mindepth 1 -type d); do
        if [ -d "${d}/.git" ]; then
            echo "-- Entering ${d}"
            git -C "${d}" ${=command}
        fi
    done
}

# usage gh_approve https://github.com/user/repo/pull/1234
function gh_approve() {
    for url in "$@"; do
        local api_url="$(echo "${url}" | sed 's#https://github.com/\([^/]*\)/\([^/]*\)/pull/\([^/]*\)#https://api.github.com/repos/\1/\2/pulls/\3/reviews#g')"

        curl -H "Authorization: token ${GITHUB_TOKEN}" "${api_url}" -d '{ "event": "APPROVE" }'

        shift
    done
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

# Fancy Ctrl+R (brew install fzf, then /usr/local/opt/fzf/install)
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}'"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='rg --files --hidden'

# git fzf integration
# https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
# defined aliases:
# ^G ^F: files (gf)
# ^G ^B: brances (gb)
# ^G ^T: tags (gt)
# ^G ^R: remotes (gr)
# ^G ^H: hashes (gh)
source "${DOTFILES_REPO}/fzf-git.sh"

# brew install nvm
enable-nvm() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
}

# https://iterm2.com/documentation-shell-integration.html
# curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
source ~/.iterm2_shell_integration.zsh

# setup python for
# https://github.com/martong/ycm_extra_conf.jsondb
export PYTHONPATH="${DOTFILES_REPO}/ycm_extra_conf.jsondb:${PYTHONPATH}"

#swap file location for vim
mkdir -p ~/.vim/swp

#export EDITOR for github's gh CLI tool
export EDITOR='vim'

#vim
alias v='vim'

#git
alias g='git'

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

# Tells 'less' not to paginate if less than a page
export LESS="-F -X $LESS"

if test -f ~/.bashrc_local; then
    source ~/.bashrc_local
fi
alias bach="/Users/r0mai/prezi/frontend-packages/node_modules/.bin/bach"
alias ci="/Users/r0mai/prezi/frontend-packages/node_modules/.bin/ci"

if which lsd > /dev/null; then
    unalias la
    unalias ll
    alias la="lsd -la"
    alias ll="lsd -l"
fi

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# brew install zsh-syntax-highlighting
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

# Comments are not visible in the Solarized mode, so override the color
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=green,bold'

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
