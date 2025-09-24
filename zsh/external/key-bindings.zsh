# =============================================================================
# Key Bindings Configuration
# =============================================================================
# This file contains all custom key bindings for better organization.

# =============================================================================
# BASIC KEY BINDINGS
# =============================================================================

# Remove default bindings
bindkey -r '^l'
bindkey -r '^g'

# Custom key bindings
bindkey -s '^g' 'git status\n'  # ^G for git status
bindkey -s '^l' 'clear\n'       # ^L for clear

# History search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# =============================================================================
# CUSTOM WIDGETS
# =============================================================================

# Function to open file explorer (yazi)
texplorer() {
    zle -I
    zsh -ic yazi
}
zle -N texplorer
bindkey -M viins '^E' texplorer
bindkey -M vicmd '^E' texplorer

# Function to open lazygit
lazygiit() {
    zle -I
    zsh -ic lazygit
}
zle -N lazygiit
bindkey -M viins '^G' lazygiit
bindkey -M vicmd '^G' lazygiit

# Function to reload zsh configuration
reload() {
    source "$ZDOTDIR/.zshrc"
    echo "Zsh configuration reloaded!"
}
zle -N reload

# =============================================================================
# VI MODE SPECIFIC BINDINGS
# =============================================================================
# Vi mode history search
bindkey -M viins '^P' up-line-or-search
bindkey -M viins '^N' down-line-or-search

# =============================================================================
# FZF KEY BINDINGS
# =============================================================================

# FZF file search (Ctrl+T)
bindkey -M viins '^T' fzf-file-widget
bindkey -M vicmd '^T' fzf-file-widget

# FZF directory search (Alt+C)
bindkey -M viins '\ec' fzf-cd-widget
bindkey -M vicmd '\ec' fzf-cd-widget

# FZF history search (Ctrl+R)
bindkey -M viins '^R' fzf-history-widget
bindkey -M vicmd '^R' fzf-history-widget

# =============================================================================
# CONVENTIONAL COMMIT HELPER
# =============================================================================

# Conventional commit helper (Ctrl+X)
fzf_conventional_commit-widget() {
    commit_type=("${(f)"$(grep -vE '^#' $DOTFILES/zsh/external/fzf-conventional-commit/commit-type)"}")
    commit_emoji=("${(f)"$(grep -vE '^#' $DOTFILES/zsh/external/fzf-conventional-commit/commit-emoji)"}")
    
    temp_option=""
    local selected
    if [[ -z "$temp_option" ]]; then
        selected=$(printf "%s\n" "${commit_type[@]}" | fzf +s +m --multi --reverse --prompt="> ")
        if [[ -n "$selected" ]]; then
            temp_option=$(echo "$selected" | cut -d':' -f1)
            selected=$(printf "%s\n" "${commit_emoji[@]}" | fzf +s +m --multi --reverse --prompt="> ")
            if [[ -n "$selected" ]]; then
                temp_scope=$(echo "$selected" | cut -d'-' -f2)
                LBUFFER+="$temp_option:$temp_scope"
                temp_option=""
            fi
        fi
    fi
    zle reset-prompt
}
zle -N fzf_conventional_commit-widget
bindkey -M viins '^X' fzf_conventional_commit-widget
bindkey -M vicmd '^X' fzf_conventional_commit-widget

# =============================================================================
# UTILITY BINDINGS
# =============================================================================

# Simple search widget
fif-widget() {
    fif
    zle reset-prompt
}

# Register widget
zle -N fif-widget

# Key binding
bindkey -M viins '^f' fif-widget  # Alt+F: Search in files
bindkey -M vicmd '^f' fif-widget  # Alt+F: Search in files

# =============================================================================
# DEBUGGING BINDINGS (Optional)
# =============================================================================

# Uncomment for debugging
# bindkey -s '^B' 'echo "Debug: Current directory is $(pwd)"\n'
# bindkey -s '^V' 'echo "Debug: ZSH version is $ZSH_VERSION"\n'
