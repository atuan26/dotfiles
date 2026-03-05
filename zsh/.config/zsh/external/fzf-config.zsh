# =============================================================================
# FZF Configuration
# =============================================================================
# This file contains all FZF-related configuration for better organization.

# FZF vi bindings (command mode only)
FZF_VI_BIND_LIST=(
    "j:down"
    "k:up"
    "n:down"
    "p:up"
    "tab:down"
    "shift-tab:up"
    "ctrl-j:down"          # Works in both modes
    "ctrl-k:up"            # Works in both modes
    "g:first"
    "G:last"
    "ctrl-d:preview-half-page-down"
    "ctrl-u:preview-half-page-up"
    "ctrl-f:preview-page-down"
    "ctrl-b:preview-page-up"
    "z:jump"
    "q:abort"
    "D:clear-query"
    "r:toggle-sort"
    "m:toggle+down"        # Better multi-select
    "space:toggle+down"    # Toggle and move down
    "ctrl-a:select-all"
    "ctrl-n:deselect-all"
    "y:execute-silent(echo -n {} | xclip -selection clipboard)"  # Yank current item
)

# Build FZF bindings
declare FZF_VI_BIND="" FZF_VI_REBIND="" FZF_VI_UNBIND=""

# Headers for different modes
FZF_NORMAL_HEADER="[NORMAL] i/a/S: insert | v: preview | y: yank | space: select | C-a: all"
FZF_INSERT_HEADER="[INSERT] ESC: normal | v: preview | C-j/k: navigate"

cursor_block='\e[2 q'
cursor_beam='\e[6 q'

# Generate unbind/rebind for alphanumeric characters only
# (disable-search already prevents typing, this is just extra safety)
for char in {a..z} {A..Z} {0..9}; do
    # Skip special mode-switching keys
    if [[ ! "$char" =~ ^[iaS]$ ]]; then
        FZF_VI_UNBIND+="unbind($char)+"
        FZF_VI_REBIND+="rebind($char)+"
    fi
done

for bind in "${FZF_VI_BIND_LIST[@]}"; do
    KEY="${bind%%:*}"
    ACTION="${bind##*:}"
    FZF_VI_BIND+="$KEY:$ACTION,"
    
    # Don't unbind ctrl- keys (they work in both modes)
    if [[ ! "$KEY" =~ ^ctrl- ]]; then
        FZF_VI_UNBIND+="unbind($KEY)+"
        FZF_VI_REBIND+="rebind($KEY)+"
    fi
done

# Mode switching with header updates
FZF_SWITCH_TO_NORMAL="disable-search+change-header($FZF_NORMAL_HEADER)+execute-silent(echo -n \"$cursor_block\")"
FZF_SWITCH_TO_INSERT="enable-search+change-header($FZF_INSERT_HEADER)+execute-silent(echo -n \"$cursor_beam\")"

FZF_VI_BIND+="enter:accept"
FZF_VI_UNBIND+="unbind(i)+unbind(a)+unbind(/)+unbind(S)+$FZF_SWITCH_TO_INSERT"
FZF_VI_REBIND+="rebind(i)+rebind(a)+rebind(/)+rebind(S)+$FZF_SWITCH_TO_NORMAL"

# FZF default options
export FZF_DEFAULT_OPTS="
    --pointer='▶' \
    --marker='✓' \
    --prompt='❯ ' \
    --height=~70% \
    --border=rounded \
    --layout=reverse \
    --info=inline \
    --multi \
    --cycle \
    --bind='$FZF_VI_BIND' \
    --bind='start:$FZF_SWITCH_TO_NORMAL' \
    --bind='esc:$FZF_VI_REBIND' \
    --bind='i:$FZF_VI_UNBIND' \
    --bind='a:$FZF_VI_UNBIND+end-of-line' \
    --bind='/:$FZF_VI_UNBIND' \
    --bind='S:$FZF_VI_UNBIND+clear-query' \
    --bind='v:toggle-preview' \
    --bind='?:toggle-preview' \
    --color='fg:#c0caf5,bg:#1a1b26,hl:#7aa2f7' \
    --color='fg+:#c0caf5,bg+:#283457,hl+:#7dcfff' \
    --color='info:#7aa2f7,prompt:#7dcfff,pointer:#f7768e' \
    --color='marker:#9ece6a,spinner:#f7768e,header:#7aa2f7' \
    --header='$FZF_NORMAL_HEADER'
"

# FZF commands
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude '.git' --exclude 'node_modules'"
export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude '.git' --exclude 'node_modules'"

# Smart preview script
FZF_PREVIEW='
if [ -d {} ]; then
    eza --tree --level=2 --color=always --icons {}
elif file --mime {} | grep -q "text/"; then
    bat -n --color=always --line-range :500 {} || cat {}
elif file --mime {} | grep -qE "image/|video/|audio/"; then
    file {} && echo && exiftool {} 2>/dev/null || file -b {}
else
    bat -n --color=always --line-range :500 {} 2>/dev/null || cat {}
fi
'

# FZF options for different commands
export FZF_CTRL_T_OPTS="
  --preview='$FZF_PREVIEW' \
  --preview-window='right:60%:wrap' \
  --bind='ctrl-/:change-preview-window(right,70%|right,40%|hidden|)' \
  --bind='ctrl-e:execute(${EDITOR:-vim} {} < /dev/tty > /dev/tty)' \
  --header='C-/: preview | C-e: edit'
"

export FZF_CTRL_R_OPTS="
  --preview='echo {}' \
  --preview-window='up:3:hidden:wrap' \
  --bind='ctrl-/:toggle-preview' \
  --bind='ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort' \
  --bind='ctrl-e:execute(echo {2..} | xclip -selection clipboard)' \
  --header='C-y: copy & exit | C-e: copy | C-/: preview'
"

export FZF_ALT_C_OPTS="
  --preview='eza --tree --level=2 --color=always --icons {}' \
  --preview-window='right:60%' \
  --header='Choose directory to cd'
"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude '.git' --exclude 'node_modules'"
