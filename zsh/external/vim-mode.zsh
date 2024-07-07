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

# Start up in command mode
zle-line-init() {
    zle -K vicmd;
    echo -ne $cursor_block
}

zle -N zle-keymap-select
zle -N zle-line-init

bindkey -M menuselect 'h' vi-backward-char
# bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
# bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# "/" vi-history-search-backward
# "?" vi-history-search-forward

bindkey -M vicmd "?" vi-history-search-backward
bindkey -M vicmd "/" vi-history-search-forward

# bindkey -M vicmd "?" history-incremental-search-backward
# bindkey -M vicmd "/" history-incremental-search-forward
# bindkey -M isearch '^N' history-incremental-search-backward
# bindkey -M isearch '^R' history-incremental-search-forward

# make search up and down work, so partially type and hit up/down to find relevant stuff
bindkey '^[[A' up-line-or-search                                                
bindkey '^[[B' down-line-or-search

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


# # Remove binding for execute-named-cmd,  : in normal mode # bindkey -e -r '^[x' # bindkey -a -r ':'

# function zle-keymap-select() {
#   # update keymap variable for the prompt
#   VI_KEYMAP=$KEYMAP

#   # change cursor style in vi-mode
#   # case $KEYMAP in
#   #   vicmd)      print -n -- "\E]50;CursorShape=0\C-G";; # block cursor
#   #   viins|main) print -n -- "\E]50;CursorShape=1\C-G";; # line cursor
#   # esac

#   zle reset-prompt
#   zle -R
# }

# zle -N zle-keymap-select

# function vi-accept-line() {
#   VI_KEYMAP=main
#   zle accept-line
# }

# zle -N vi-accept-line

# # NORMAL Mode Indicator
# if [[ -z "$MODE_INDICATOR" ]]; then
#   MODE_INDICATOR='%B%F{red}◀︎◀︎◀︎%b%f'
# fi

# # export KEYTIMEOUT=25

# bindkey -v
# bindkey -M viins kj vi-cmd-mode

# # use custom accept-line widget to update $VI_KEYMAP
# bindkey -M vicmd '^J' vi-accept-line
# bindkey -M vicmd '^M' vi-accept-line

# # allow v to edit the command line (standard behaviour)
# # autoload -Uz edit-command-line
# # zle -N edit-command-line
# # bindkey -M vicmd 'v' edit-command-line

# # allow ctrl-p, ctrl-n for navigate history (standard behaviour)
# bindkey '^P' up-history
# bindkey '^N' down-history

# # allow ctrl-h, ctrl-w, ctrl-? for char and word deletion (standard behaviour)
# bindkey '^?' backward-delete-char
# bindkey '^h' backward-delete-char
# bindkey '^w' backward-kill-word

# # allow ctrl-r and ctrl-s to search the history
# bindkey '^r' history-incremental-search-backward
# bindkey '^s' history-incremental-search-forward

# # allow ctrl-a and ctrl-e to move to beginning/end of line
# bindkey '^e' end-of-line
# bindkey '^a' beginning-of-line

# # helps with zsh-autosuggestions
# bindkey '^ ' end-of-line

# # if mode indicator wasn't setup by theme, define default
# # if [[ "$MODE_INDICATOR" == "" ]]; then
# #   MODE_INDICATOR="%{$fg_bold[red]%}<%{$fg[red]%}<<%{$reset_color%}"
# # fi

# function vi_mode_prompt_info() {
#   echo "${${VI_KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
# }

# # define right prompt, if it wasn't defined by a theme
# if [[ "$RPS1" == "" && "$RPROMPT" == "" ]]; then
#   RPS1='$(vi_mode_prompt_info)'
# fi
