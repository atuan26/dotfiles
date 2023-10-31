fzf_conventional_commit-widget() {
    commit_type=("${(f)"$(grep -vE '^#' ~/.fzf-conventional-commit/commit-type)"}")

    commit_emoji=("${(f)"$(grep -vE '^#' ~/.fzf-conventional-commit/commit-emoji)"}")

    temp_option=""
    local selected
    if [[ -z "$temp_option" ]]; then
        selected=$(printf "%s\n" "${commit_type[@]}" | fzf  +s +m --multi --reverse --prompt="> ")
        if [[ -n "$selected" ]]; then
            temp_option=$(echo "$selected" | cut -d':' -f1)
            selected=$(printf "%s\n" "${commit_emoji[@]}"  | fzf  +s +m --multi --reverse --prompt="> ")
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

bindkey '^X' fzf_conventional_commit-widget