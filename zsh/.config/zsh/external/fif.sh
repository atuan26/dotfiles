# Lazy loading content search with FZF
fif() {
    # Check if ripgrep is available
    if ! command -v rg >/dev/null 2>&1; then
        echo "Error: ripgrep (rg) is required for this function"
        return 1
    fi

    # Create a state file to track options
    local state_file=$(mktemp)
    echo "0 0 0" > "$state_file"  # case_sensitive whole_word regex_mode
    
    # Create a simple header
    local header_file=$(mktemp)
    echo "🔍 Search in files | Ctrl-C: case, Ctrl-W: word, Ctrl-R: regex" > "$header_file"

    # Create a temporary script for the search command
    local temp_script=$(mktemp)
    cat > "$temp_script" << 'EOF'
#!/bin/bash
query="$1"
state_file="$2"

# Read current state
read case_sensitive whole_word regex_mode < "$state_file"

# Build colored status indicators
status=""
[ "$case_sensitive" = "1" ] && status="${status}\033[32m[C]\033[0m" || status="${status}\033[90m[C]\033[0m"
[ "$whole_word" = "1" ] && status="${status}\033[32m[W]\033[0m" || status="${status}\033[90m[W]\033[0m"
[ "$regex_mode" = "1" ] && status="${status}\033[32m[R]\033[0m" || status="${status}\033[90m[R]\033[0m"

# Show status message when no query
if [ -z "$query" ]; then
    # Build status indicators
    status=""
    [ "$case_sensitive" = "1" ] && status="${status}[C]"
    [ "$whole_word" = "1" ] && status="${status}[W]"
    [ "$regex_mode" = "1" ] && status="${status}[R]"
    
    if [ -n "$status" ]; then
        echo "Ready to search... $status (Ctrl-C: case, Ctrl-W: word, Ctrl-R: regex)"
    else
        echo "Ready to search... (Ctrl-C: case, Ctrl-W: word, Ctrl-R: regex)"
    fi
    exit 0
fi

# Add delay for lazy loading
sleep 0.3

# Build ripgrep command with options
rg_cmd="rg --line-number --no-heading --color=always"

# Add case sensitivity
if [ "$case_sensitive" != "1" ]; then
    rg_cmd="$rg_cmd --ignore-case"
fi

# Add whole word matching
if [ "$whole_word" = "1" ]; then
    rg_cmd="$rg_cmd --word-regexp"
fi

# Add regex mode (default is smart case, so no extra flag needed)
# If not regex mode, escape special characters
if [ "$regex_mode" != "1" ]; then
    query=$(printf '%s\n' "$query" | sed 's/[[\.*^$()+?{|]/\\&/g')
fi

# Search and format output with colors
$rg_cmd "$query" . 2>/dev/null | \
while IFS=: read -r file line_num content; do
    # Get terminal width for dynamic formatting
    local term_width=$(tput cols 2>/dev/null || echo 80)
    local file_width=$((term_width / 3))
    local content_width=$((term_width - file_width - 10))
    
    # Truncate file name if too long
    if [ ${#file} -gt $file_width ]; then
        file="...${file: -$((file_width-3))}"
    fi
    
    # Truncate content if too long
    if [ ${#content} -gt $content_width ]; then
        content="${content:0:$((content_width-3))}..."
    fi
    
    # Format: file_name:line_no:line_content (with colors)
    printf "%s:%s:%s\n" "$file" "$line_num" "$content"
done
EOF

    chmod +x "$temp_script"

    # Create toggle scripts for each option
    local toggle_case=$(mktemp)
    cat > "$toggle_case" << EOF
#!/bin/bash
state_file="\$1"
temp_script="$temp_script"
read case_sensitive whole_word regex_mode < "\$state_file"
case_sensitive=\$((1 - case_sensitive))
echo "\$case_sensitive \$whole_word \$regex_mode" > "\$state_file"

# Pass current query to continue searching with new settings
exec "\$temp_script" "{q}" "\$state_file"
EOF

    local toggle_word=$(mktemp)
    cat > "$toggle_word" << EOF
#!/bin/bash
state_file="\$1"
temp_script="$temp_script"
read case_sensitive whole_word regex_mode < "\$state_file"
whole_word=\$((1 - whole_word))
echo "\$case_sensitive \$whole_word \$regex_mode" > "\$state_file"

# Pass current query to continue searching with new settings
exec "\$temp_script" "{q}" "\$state_file"
EOF

    local toggle_regex=$(mktemp)
    cat > "$toggle_regex" << EOF
#!/bin/bash
state_file="\$1"
temp_script="$temp_script"
read case_sensitive whole_word regex_mode < "\$state_file"
regex_mode=\$((1 - regex_mode))
echo "\$case_sensitive \$whole_word \$regex_mode" > "\$state_file"

# Pass current query to continue searching with new settings
exec "\$temp_script" "{q}" "\$state_file"
EOF

    chmod +x "$toggle_case" "$toggle_word" "$toggle_regex"


    # Run FZF with lazy loading and option toggles
    local result
    result=$(fzf \
        --bind="change:reload($temp_script {q} $state_file)" \
        --bind="start:reload($temp_script {q} $state_file)" \
        --bind="ctrl-c:reload($toggle_case $state_file)" \
        --bind="ctrl-w:reload($toggle_word $state_file)" \
        --bind="ctrl-r:reload($toggle_regex $state_file)" \
        --preview="if [ -n '{1}' ] && [ -f '{1}' ] && [ '{2}' -eq '{2}' ] 2>/dev/null; then bat --color=always --style=header,grid --line-range {2}:300 {1}; else echo 'No file selected'; fi" \
        --preview-window="right:50%:wrap" \
        --height="80%" \
        --min-height="20" \
        --header="$(cat $header_file)" \
        --delimiter=":" \
        --with-nth=1,2,3 \
        --query="" \
        --layout=reverse \
        --border \
        --margin=1 \
        --ansi)

    # Clean up
    rm -f "$temp_script" "$state_file" "$toggle_case" "$toggle_word" "$toggle_regex" "$header_file"

    # Process result
    if [ -n "$result" ]; then
        # Clean the result to remove any control characters and ANSI codes
        result=$(echo "$result" | sed 's/\x1b\[[0-9;]*m//g' | tr -d '\0' | sed 's/\^@//g')
        
        # Parse the new format: file_name:line_no:line_content
        local file=$(echo "$result" | cut -d: -f1)
        local line_num=$(echo "$result" | cut -d: -f2)
        
        # Validate that we have both file and line number
        if [ -n "$file" ] && [ -n "$line_num" ] && [[ "$line_num" =~ ^[0-9]+$ ]]; then
            # Remove any remaining control characters from file path
            file=$(echo "$file" | tr -d '\0' | sed 's/\^@//g')
            echo "Opening: $file at line $line_num"
            ${EDITOR:-nvim} "+$line_num" "$file"
        else
            echo "Invalid selection or parsing error"
            echo "Result: $result"
        fi
    fi
}
