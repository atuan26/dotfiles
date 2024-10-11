# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source ~/.bash_profile

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# zstyle ':fzf-tab:complete:*:*' extra-opts --preview=$extract";$PREVIEW \$in"

# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# zstyle ':completion:*' menu no
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
# zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' fzf-pad 6

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git fzf-tab zsh-syntax-highlighting zsh-autosuggestions fzf)

source $ZSH/oh-my-zsh.sh

# Fix suggestion on paste
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias py="python3"
alias python="python3"
alias cls="clear"
alias catt=bat

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/tuanna/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/tuanna/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/tuanna/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/tuanna/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH=$PATH:/Users/pro/.nexustools

# batdiff() {
#     git diff --name-only --relative --diff-filter=d | xargs bat --diff
# }

# ch() {
#   local cols sep
#   cols=$(( COLUMNS / 3 ))
#   sep='{::}'

#   cp -f ~/Library/Application\ Support/Google/Chrome/Profile\ 1/History /tmp/h

#   sqlite3 -separator $sep /tmp/h \
#     "select substr(title, 1, $cols), url
#      from urls order by last_visit_time desc" |
#   awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
#   fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs open
# }

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/pro/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/pro/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/pro/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/pro/Downloads/google-cloud-sdk/completion.zsh.inc'; fi


# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

export PATH="$PATH:~/.local/bin/"
eval $(thefuck --alias)

: '
####################
#        FZF       #
####################
TODO:
    - Add change between preview bind:
           change-preview(...)          (change --preview option)
           change-preview-label(...)    (change --preview-label to the given string)
    - toggle-search  OR  enable-search/disabel-search
    - Add min-height
'
# ??? --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"

FZF_VI_BIND_LIST=("j:down"
            "k:up"
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
            "tab:down"
            "shift-tab:up"
)
declare FZF_VI_BIND="" FZF_VI_REBIND="" FZF_VI_UNBIND=""
FZF_BROWSER_MODE_PROMPT="Tips: j/k: navigate, d/u: navigate preview 🪄️ "
FZF_QUERY_MODE_PROMPT="QUERY MODE 🔎 "

cursor_block='\e[0 q'
cursor_beam='\e[5 q'
for bind in "${FZF_VI_BIND_LIST[@]}" ; do
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
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude '.git' --exclude 'node_modules'"

export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude '.git' --exclude 'node_modules'"
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'F2:change-preview-window(right|hidden|)'
  --bind 'ctrl-d:reload(fd --type d --hidden --follow --exclude '.git' --exclude 'node_modules'),ctrl-f:reload(eval "$FZF_CTRL_T_COMMAND")'
  --header 'F2: change preview window'
  "

export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'F2:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color='header:italic:underline,label:blue' \
  --header 'CTRL-Y: copy command into clipboard; F2: toggle preview'"

export FZF_ALT_C_OPTS="--preview 'tree -C {}'
  --header 'Choose directory to cd'"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude '.git' --exclude 'node_modules'"


# auto complete conda activate environment
_fzf_conda_activate() {
    local envs="$(conda env list | awk '!/^(#|\*|base)/ {print $1}')"
    local env=$(echo "$envs" | fzf +s +m --height=50% --reverse)
    if [[ -n "$env" ]]; then
        COMPREPLY=("$env")
    fi
}

_conda_activate() {
    local cur_word=${COMP_WORDS[COMP_CWORD]}
    echo $cur_word
    if [[ "$cur_word" == "" ]]; then
        _fzf_conda_activate
    fi
}

complete -o default -o bashdefault -F _conda_activate conda

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}

fpath=($ZDOTDIR/external $fpath)
autoload -U compinit && compinit

_comp_options+=(globdots)

zmodload zsh/complist

# change clear shell from C-l to C-g
bindkey -r '^l'
bindkey -r '^g'
bindkey -s '^g' 'clear\n'

PATH="$HOME/.local/bin:$PATH"
eval "$(fzf --zsh)"
eval "$(fnm env --use-on-cd&>/dev/null)"
eval "$(zoxide init zsh)"

source "$XDG_CONFIG_HOME/zsh/aliases"
for file in $DOTFILES/zsh/external/*; do
    source "$file"
done

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


. "$HOME/.cargo/env"
source $HOME/.cargo/env

# fnm
FNM_PATH="$HOME/.config/local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$HOME/.config/local/share/fnm:$PATH"
  eval "`fnm env`"
fi

