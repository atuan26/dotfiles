# For dotfiles
export XDG_CONFIG_HOME="$HOME/.config" # For specific data
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share" # For cached files
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

export EDITOR="nvim"
export VISUAL="nvim"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh" # History filepath
export HISTFILE="$ZDOTDIR/.zhistory" # Maximum events for internal history
export HISTSIZE=10000
# Maximum events in history file
export SAVEHIST=10000
export DOTFILES="$HOME/dotfiles"

export CONDA_AUTO_ACTIVATE_BASE=false

# macOS Homebrew PATH setup
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    # Apple Silicon Mac
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    # Intel Mac
    eval "$(/usr/local/bin/brew shellenv)"
fi

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
