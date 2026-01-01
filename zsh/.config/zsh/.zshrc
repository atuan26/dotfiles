#!/usr/bin/env zsh
# =============================================================================
# ZSH Configuration
# =============================================================================
# This file is organized into logical sections for better maintainability.
# Each section is clearly marked and can be easily modified or disabled.

# =============================================================================
# 1. ENVIRONMENT SETUP
# =============================================================================

# Set ZDOTDIR if not already set
export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"

# Set DOTFILES directory (for backward compatibility)
export DOTFILES="${DOTFILES:-$HOME/Documents/dotfiles}"

# =============================================================================
# 2. OH-MY-ZSH CONFIGURATION
# =============================================================================

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Auto-install Oh My Zsh if not present
if [[ ! -d "$ZSH" ]]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Oh My Zsh not found. Installing automatically..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Backup current .zshrc if it exists
    if [[ -f "$ZDOTDIR/.zshrc" ]]; then
        cp "$ZDOTDIR/.zshrc" "$ZDOTDIR/.zshrc.backup-$(date +%Y%m%d-%H%M%S)"
        echo "✓ Backed up current .zshrc"
    fi
    
    # Install Oh My Zsh in unattended mode with KEEP_ZSHRC to prevent overwriting
    if command -v curl &> /dev/null; then
        RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    elif command -v wget &> /dev/null; then
        RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "Error: Neither curl nor wget found. Please install one of them."
        echo "  sudo pacman -S curl"
        return 1
    fi
    
    # Restore our custom .zshrc if Oh My Zsh created a default one
    if [[ -f "$ZDOTDIR/.zshrc.pre-oh-my-zsh" ]]; then
        mv "$ZDOTDIR/.zshrc.pre-oh-my-zsh" "$ZDOTDIR/.zshrc"
        echo "✓ Restored custom .zshrc"
    fi
    
    if [[ -d "$ZSH" ]]; then
        echo "✓ Oh My Zsh installed successfully!"
    else
        echo "✗ Oh My Zsh installation failed. Continuing without it..."
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

ZSH_THEME="custom"

# Plugin configuration
plugins=(
    git
    aws
    fzf
    github
    pass
    azure
)

# Oh-my-zsh settings
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_MAGIC_FUNCTIONS="true"

# Load oh-my-zsh
if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi

# =============================================================================
# 3. ENVIRONMENT VARIABLES
# =============================================================================

# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# Language
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# History configuration
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"

# =============================================================================
# 4. PATH CONFIGURATION
# =============================================================================

# Add local bin directories to PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Add conda to PATH if it exists
if [[ -d "$HOME/miniconda3/bin" ]]; then
    export PATH="$HOME/miniconda3/bin:$PATH"
fi

# Add fnm to PATH if it exists
if [[ -d "$HOME/.config/local/share/fnm" ]]; then
    export PATH="$HOME/.config/local/share/fnm:$PATH"
fi

# Add Ruby gems to PATH if they exist
if [[ -d "$HOME/.config/local/share/gem/ruby" ]]; then
    export PATH="$PATH:$HOME/.config/local/share/gem/ruby/3.4.0/bin"
fi

# =============================================================================
# 5. ZSH OPTIONS
# =============================================================================

# History options
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

# Other useful options
setopt AUTO_CD
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# =============================================================================
# 6. COMPLETION SYSTEM
# =============================================================================

# Initialize completion system
autoload -Uz compinit
compinit

# Completion options
_comp_options+=(globdots)

# Load completion modules
zmodload zsh/complist

# FZF-Tab configuration
zstyle ':fzf-tab:*' fzf-pad 6
zstyle ':completion:*:*:aws' fzf-search-display true

# =============================================================================
# 7. KEY BINDINGS
# =============================================================================

# Vi mode
bindkey -v
export KEYTIMEOUT=5

# Key bindings are now loaded from external/key-bindings.zsh

# =============================================================================
# 8. ALIASES
# =============================================================================
# Aliases are now loaded from external/aliases.zsh

# =============================================================================
# 9. HELPER FUNCTIONS
# =============================================================================
# Helper functions are now loaded from external/key-bindings.zsh

# =============================================================================
# 10. TOOL INITIALIZATION
# =============================================================================

# Initialize tools with error suppression
eval "$(fzf --zsh 2>/dev/null)"
eval "$(fnm env --use-on-cd 2>/dev/null)"
eval "$(zoxide init zsh 2>/dev/null)"

# Cargo/Rust
if [[ -f "$HOME/.cargo/env" ]]; then
    . "$HOME/.cargo/env"
fi

# Conda initialization
if [[ -f "$HOME/miniconda3/bin/conda" ]]; then
    __conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
            . "$HOME/miniconda3/etc/profile.d/conda.sh"
        fi
    fi
    unset __conda_setup
fi

# Google Cloud SDK
if [[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]]; then
    . "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]]; then
    . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# =============================================================================
# 11. FZF CONFIGURATION
# =============================================================================
# FZF configuration is now loaded from external/fzf-config.zsh

# =============================================================================
# 12. CUSTOM COMPLETIONS
# =============================================================================

# Conda environment completion
_fzf_conda_activate() {
    local envs="$(conda env list | awk '!/^(#|\*|base)/ {print $1}')"
    local env=$(echo "$envs" | fzf +s +m --height=50% --reverse)
    if [[ -n "$env" ]]; then
        COMPREPLY=("$env")
    fi
}

_conda_activate() {
    local cur_word=${COMP_WORDS[COMP_CWORD]}
    if [[ "$cur_word" == "" ]]; then
        _fzf_conda_activate
    fi
}

complete -o default -o bashdefault -F _conda_activate conda

# FZF completion runner
_fzf_comprun() {
    local command=$1
    shift
    case "$command" in
        cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
        export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
        ssh)          fzf --preview 'dig {}'                   "$@" ;;
        *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
    esac
}

# =============================================================================
# 13. EXTERNAL SCRIPTS
# =============================================================================

# Load aliases
if [[ -f "$XDG_CONFIG_HOME/zsh/aliases" ]]; then
    source "$XDG_CONFIG_HOME/zsh/aliases"
fi

# Load external zsh scripts, plugins
for file in "$ZDOTDIR/external"/*.{zsh,sh}; do
    [[ -f "$file" ]] && source "$file"
done
source $ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# =============================================================================
# 14. POST-INITIALIZATION
# =============================================================================

# Fix suggestion on paste
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)

# Add fpath for custom completions
fpath=("$ZDOTDIR/external" $fpath)
fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)

# zsh-completions: You may have to force rebuild zcompdump:
# rm -f ~/.zcompdump; compinit

# =============================================================================
# 15. DEBUGGING (Optional)
# =============================================================================

# Uncomment to enable startup timing
# if [[ -n "$ZSH_STARTUP_DEBUG" ]]; then
#     echo "🐚 Zsh configuration loaded successfully!"
# fi