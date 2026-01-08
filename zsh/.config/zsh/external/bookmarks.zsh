# Command Bookmarks - Save and quickly run important/long commands
# Storage: ~/.local/share/cmd-bookmarks

BOOKMARKS_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/cmd-bookmarks"

# Add a command bookmark (interactive)
# Usage: bm-add [command] [description]
#   - No args: select from history with fzf, then prompt for description
#   - With args: bm-add "command" "description"
bm-add() {
    local cmd="$1"
    local desc="$2"
    
    # If no command provided, select from history
    if [[ -z "$cmd" ]]; then
        cmd=$(fc -ln 1 | tac | awk '!seen[$0]++' | fzf \
            --header="Select command to bookmark" \
            --preview-window=hidden \
            --height=50% \
        )
        [[ -z "$cmd" ]] && return 0
        cmd=$(echo "$cmd" | sed 's/^[[:space:]]*//')
    fi
    
    # If no description provided, prompt for it
    if [[ -z "$desc" ]]; then
        echo "Command: $cmd"
        echo -n "Description: "
        read desc
        [[ -z "$desc" ]] && desc="No description"
    fi
    
    mkdir -p "$(dirname "$BOOKMARKS_FILE")"
    echo "${desc}	${cmd}" >> "$BOOKMARKS_FILE"
    echo "✓ Bookmarked: $desc"
}

# Add last command to bookmarks
# Usage: bm-last [description]
#   - No args: prompt for description
#   - With arg: use provided description
bm-last() {
    local last_cmd=$(fc -ln -1 | sed 's/^[[:space:]]*//')
    local desc="$1"
    
    echo "Command: $last_cmd"
    
    # If no description provided, prompt for it
    if [[ -z "$desc" ]]; then
        echo -n "Description: "
        read desc
        [[ -z "$desc" ]] && desc="No description"
    fi
    
    mkdir -p "$(dirname "$BOOKMARKS_FILE")"
    echo "${desc}	${last_cmd}" >> "$BOOKMARKS_FILE"
    echo "✓ Bookmarked: $desc"
}

# Search and run bookmarked commands with fzf
# Usage: bm (or Ctrl+B)
bm() {
    [[ ! -f "$BOOKMARKS_FILE" ]] && { echo "No bookmarks yet. Use bm-add or bm-last"; return 1; }
    
    local selected=$(cat "$BOOKMARKS_FILE" | fzf \
        --delimiter='\t' \
        --with-nth=1 \
        --preview='echo -e "\033[1;33mCommand:\033[0m\n{2}"' \
        --preview-window=up:3:wrap \
        --header="Enter=run, Ctrl-Y=copy, Ctrl-E=edit file" \
        --bind='ctrl-y:execute-silent(echo -n {2} | xclip -selection clipboard)+abort' \
        --bind='ctrl-e:execute(${EDITOR:-nvim} '"$BOOKMARKS_FILE"')+abort' \
    )
    
    [[ -z "$selected" ]] && return 0
    
    local cmd=$(echo "$selected" | cut -f2)
    print -s "$cmd"  # Add to history
    eval "$cmd"
}

# List all bookmarks
bm-list() {
    [[ ! -f "$BOOKMARKS_FILE" ]] && { echo "No bookmarks yet."; return 0; }
    
    echo "Command Bookmarks:"
    echo "=================="
    awk -F'\t' '{printf "\033[1;33m%s\033[0m\n  %s\n\n", $1, $2}' "$BOOKMARKS_FILE"
}

# Edit bookmarks file
bm-edit() {
    mkdir -p "$(dirname "$BOOKMARKS_FILE")"
    ${EDITOR:-nvim} "$BOOKMARKS_FILE"
}

# Delete a bookmark by searching
bm-del() {
    [[ ! -f "$BOOKMARKS_FILE" ]] && { echo "No bookmarks yet."; return 1; }
    
    local selected=$(cat "$BOOKMARKS_FILE" | fzf \
        --delimiter='\t' \
        --with-nth=1 \
        --preview='echo -e "\033[1;33mCommand:\033[0m\n{2}"' \
        --preview-window=up:3:wrap \
        --header="Select bookmark to DELETE" \
    )
    
    [[ -z "$selected" ]] && return 0
    
    local desc=$(echo "$selected" | cut -f1)
    grep -vF "$selected" "$BOOKMARKS_FILE" > "${BOOKMARKS_FILE}.tmp"
    mv "${BOOKMARKS_FILE}.tmp" "$BOOKMARKS_FILE"
    echo "✗ Deleted: $desc"
}

# Create widget for bookmark function
_bm_widget() {
    zle push-line
    BUFFER="bm"
    zle accept-line
}
zle -N _bm_widget

# Bind Ctrl+B to open bookmarks (both vi insert and normal mode)
bindkey -M viins '^B' _bm_widget
bindkey -M vicmd '^B' _bm_widget
