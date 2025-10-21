# =============================================================================
# Aliases Configuration
# =============================================================================
# This file contains all aliases for better organization.

# =============================================================================
# GENERAL ALIASES
# =============================================================================

# Python
alias py="python3"
alias python="python3"
alias pip="pip3"

# System
alias cls="clear"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Modern replacements
alias cat="$(command -v bat || echo cat)"
alias ls="$(command -v exa || echo ls)"
alias tree="$(command -v exa && echo 'exa --tree' || echo tree)"

# =============================================================================
# SYSTEM ALIASES
# =============================================================================

# Process management
alias ps="ps aux"
alias psg="ps aux | grep"
alias killg="killall -9"

# Network
alias ports="netstat -tuln"
alias myip="curl -s https://ipinfo.io/ip"

# =============================================================================
# EDITOR ALIASES
# =============================================================================

alias v="nvim"
alias vi="nvim"
alias vim="nvim"