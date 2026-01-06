# Updates editor information when the keymap changes.
bindkey -v

# Remove mode switching delay.
KEYTIMEOUT=5
# export KEYTIMEOUT=2

# See https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for cursors
# block blinking: '\e[1 q'
# beam blinking: '\e[5 q'
# \e[0 q: Default
# \e[1 q: blinking block.
# \e[2 q: Block
# \e[3 q: blinking underline
# \e[4 q: underline
# \e[5 q: blinking bar
# \e[6 q: bar
cursor_block='\e[1 q'
cursor_beam='\e[5 q'

function zle-keymap-select {
    # echo ${KEYMAP}
    # echo $1
    case $KEYMAP in
      vicmd)      echo -ne $cursor_block;; # block cursor
      viins|main|'') echo -ne $cursor_beam;; # line cursor
    esac

    zle reset-prompt
    zle -R
}

zle-line-init() {
    # Start up in command mode (old)
    # zle -K vicmd;
    # echo -ne $cursor_block

    # Start up in insert mode to avoid pasting issues
    zle -K viins;
    echo -ne $cursor_beam
}

# Enable bracketed paste mode
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# Key bindings for mode switching
bindkey -M viins '^[' vi-cmd-mode  # ESC to go to command mode
bindkey -M vicmd '^V' vi-insert    # Ctrl+V to go to insert mode

zle -N zle-keymap-select
zle -N zle-line-init

# Load the history search widgets
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -M menuselect 'h' vi-backward-char
# bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
# bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

bindkey -M viins "^[[A" up-line-or-beginning-search
bindkey -M viins "^[[B" down-line-or-beginning-search

# "/" vi-history-search-backward
# "?" vi-history-search-forward

# bindkey -M vicmd "?" vi-history-search-backward
# bindkey -M vicmd "/" vi-history-search-forward

# Use / and ? for incremental search in vim normal mode
bindkey -M vicmd '/' history-incremental-search-forward
bindkey -M vicmd '?' history-incremental-search-backward

# bindkey -M vicmd "?" history-incremental-search-backward
# bindkey -M vicmd "/" history-incremental-search-forward
# bindkey -M isearch '^N' history-incremental-search-backward
# bindkey -M isearch '^R' history-incremental-search-forward

# # make search up and down work, so partially type and hit up/down to find relevant stuff
# bindkey '^[[A' up-line-or-search
# bindkey '^[[B' down-line-or-search

function vi-yank-xclip {
    zle vi-yank
    # copy to X11 clipboard
    if command -v xsel > /dev/null 2>&1; then
        echo "$CUTBUFFER" | xsel -b
    elif ! command -v xsel > /dev/null 2>&1 && command -v xclip > /dev/null 2>&1; then
        echo "$CUTBUFFER" | xclip -i
    # copy to Wayland clipboard
    elif [ "$XDG_SESSION_TYPE" = "wayland" ] && command -v wl-copy > /dev/null 2>&1; then
        echo "$CUTBUFFER" | wl-copy
    # copy to macOS clipboard
    elif command -v pbcopy > /dev/null 2>&1; then
        echo "$CUTBUFFER" | pbcopy -i
    # copy to Windows clipboard
    elif command -v clip.exe > /dev/null 2>&1; then
        echo "$CUTBUFFER" | clip.exe
    elif [ -c /dev/clipboard ]; then
        echo "$CUTBUFFER" > /dev/clipboard
    else
        echo "something else"
    fi
}

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

# Adding Text Objects
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done

# Surrounding
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround


