# =============================================================================
# FZF Configuration
# =============================================================================
# This file contains all FZF-related configuration for better organization.

# FZF vi bindings
FZF_VI_BIND_LIST=(
    "j:down"
    "k:up"
    "n:down"
    "p:up"
    "tab:down"
    "shift-tab:up"
    "g:first"
    "G:last"
    "d:preview-half-page-down"
    "u:preview-half-page-up"
    "z:jump"
    "?:toggle-preview"
    "q:abort"
    "D:clear-query"
    "r:toggle-sort"
    "m:change-multi"
    "space:select"
    "ctrl-space:deselect"
)

# Build FZF bindings
declare FZF_VI_BIND="" FZF_VI_REBIND="" FZF_VI_UNBIND=""
FZF_BROWSER_MODE_PROMPT="COMMAND MODE 🪄️ "
FZF_QUERY_MODE_PROMPT="QUERY MODE 🔎 "

cursor_block='\e[0 q'
cursor_beam='\e[5 q'

for bind in "${FZF_VI_BIND_LIST[@]}"; do
    KEY="${bind%%:*}"
    ACTION="${bind##*:}"
    FZF_VI_BIND+="$KEY:$ACTION,"
    FZF_VI_UNBIND+="unbind($KEY)+"
    FZF_VI_REBIND+="rebind($KEY)+"
done

FZF_SWITCH_MODE="toggle-search+change-prompt($FZF_BROWSER_MODE_PROMPT)+execute-silent(echo \"$cursor_block\")"
FZF_VI_BIND+="enter:accept"
FZF_VI_UNBIND+="unbind(i)+unbind(a)+unbind(/)+unbind(S)+toggle-search+change-prompt($FZF_QUERY_MODE_PROMPT)+execute-silent(echo \"$cursor_beam\")"
FZF_VI_REBIND+="rebind(i)+rebind(a)+rebind(/)+rebind(S)+$FZF_SWITCH_MODE"

# FZF default options
export FZF_DEFAULT_OPTS="
    --pointer ▶ \
    --marker ⇒ \
    --height ~70% --border \
    --bind '$FZF_VI_BIND' \
    --bind 'start:$FZF_SWITCH_MODE' \
    --bind 'esc:$FZF_VI_REBIND' \
    --bind 'i:$FZF_VI_UNBIND' \
    --bind 'a:$FZF_VI_UNBIND' \
    --bind '/:$FZF_VI_UNBIND' \
    --bind 'S:$FZF_VI_UNBIND+clear-query' \
    --color='header:italic:underline,label:blue' \
    --header '?: toggle preview; i/a: Query mode; ESC: browser mode'
"

# FZF commands
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude '.git' --exclude 'node_modules'"
export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude '.git' --exclude 'node_modules'"

# FZF options for different commands
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'F2:change-preview-window(right|hidden|)'
  --bind 'ctrl-d:reload(fd --type d --hidden --follow --exclude '.git' --exclude 'node_modules'),ctrl-f:reload(eval "$FZF_CTRL_T_COMMAND")'
  --header 'F2: change preview window'
"

export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'F2:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort'
  --color='header:italic:underline,label:blue'
  --header 'CTRL-Y: copy command into clipboard; F2: toggle preview'
"

export FZF_ALT_C_OPTS="--preview 'tree -C {}' --header 'Choose directory to cd'"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude '.git' --exclude 'node_modules'"
