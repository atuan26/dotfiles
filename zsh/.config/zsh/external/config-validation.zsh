# =============================================================================
# Configuration Validation
# =============================================================================
# This file contains functions to validate and check zsh configuration.

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a file exists
file_exists() {
    [[ -f "$1" ]]
}

# Function to check if a directory exists
dir_exists() {
    [[ -d "$1" ]]
}

# Function to validate zsh configuration
validate_config() {
    local errors=0
    local warnings=0
    
    echo "🔍 Validating zsh configuration..."
    
    # Check required directories
    if ! dir_exists "$ZDOTDIR"; then
        echo "❌ ZDOTDIR not found: $ZDOTDIR"
        ((errors++))
    fi
    
    if ! dir_exists "$DOTFILES"; then
        echo "❌ DOTFILES not found: $DOTFILES"
        ((errors++))
    fi
    
    # Check oh-my-zsh
    if ! dir_exists "$ZSH"; then
        echo "⚠️  Oh My Zsh not found: $ZSH"
        ((warnings++))
    fi
    
    # Check external scripts
    if ! dir_exists "$ZDOTDIR/external"; then
        echo "❌ External scripts directory not found: $ZDOTDIR/external"
        ((errors++))
    fi
    
    # Check important commands
    local important_commands=("git" "nvim" "fzf" "fd")
    for cmd in "${important_commands[@]}"; do
        if ! command_exists "$cmd"; then
            echo "⚠️  Command not found: $cmd"
            ((warnings++))
        fi
    done
    
    # Check optional commands
    local optional_commands=("bat" "exa" "yazi" "lazygit" "zoxide" "fnm")
    for cmd in "${optional_commands[@]}"; do
        if ! command_exists "$cmd"; then
            echo "ℹ️  Optional command not found: $cmd"
        fi
    done
    
    # Summary
    echo ""
    if [[ $errors -eq 0 && $warnings -eq 0 ]]; then
        echo "✅ Configuration validation passed!"
    else
        echo "📊 Validation summary:"
        echo "   Errors: $errors"
        echo "   Warnings: $warnings"
    fi
}

# Function to show configuration info
show_config_info() {
    echo "🐚 Zsh Configuration Info:"
    echo "   ZDOTDIR: $ZDOTDIR"
    echo "   DOTFILES: $DOTFILES"
    echo "   ZSH: $ZSH"
    echo "   EDITOR: $EDITOR"
    echo "   HISTFILE: $HISTFILE"
    echo "   HISTSIZE: $HISTSIZE"
    echo ""
    echo "📁 External scripts:"
    for file in "$ZDOTDIR/external"/*.zsh; do
        if [[ -f "$file" ]]; then
            echo "   ✓ $(basename "$file")"
        fi
    done
}

# Function to reload configuration
reload_config() {
    echo "🔄 Reloading zsh configuration..."
    source "$ZDOTDIR/.zshrc"
    echo "✅ Configuration reloaded!"
}

# Make functions available
zle -N validate_config
zle -N show_config_info
zle -N reload_config
