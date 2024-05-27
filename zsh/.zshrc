# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source ~/.bash_profile

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="custom"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

zstyle ':fzf-tab:complete:*:*' extra-opts --preview=$extract";$PREVIEW \$in"

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


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
plugins=(git zsh-syntax-highlighting zsh-autosuggestions fzf-tab fzf fzf-docker)

source $ZSH/oh-my-zsh.sh

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
__conda_setup="$('/Users/pro/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/pro/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/pro/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/pro/opt/anaconda3/bin:$PATH"
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
# --bind 'j:down,k:up,ctrl-j:preview-down,ctrl-k:preview-up'
export FZF_DEFAULT_OPTS="
	 --bind '?:toggle-preview' 
	--preview 'bat -n --color=always {}' 
	--header '?: toggle preview'
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
  --color header:italic
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

_fzf_complete_doge() {
  _fzf_complete --multi --reverse --prompt="doge> " -- "$@" < <(
    echo very
    echo wow
    echo such
    echo doge
  )
}

complete -F _fzf_complete_doge -o default -o bashdefault doge

fpath=($ZDOTDIR/external $fpath)
autoload -U compinit && compinit

_comp_options+=(globdots)

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history


# make search up and down work, so partially type and hit up/down to find relevant stuff
bindkey '^[[A' up-line-or-search                                                
bindkey '^[[B' down-line-or-search

# change clear shell from C-l to C-g
bindkey -r '^l'
bindkey -r '^g'
bindkey -s '^g' 'clear\n'

PATH="$HOME/.local/bin:$PATH"
eval "$(fzf --zsh)"
eval "$(fnm env --use-on-cd)"
eval "$(zoxide init zsh)"

source "$XDG_CONFIG_HOME/zsh/aliases"
for file in $DOTFILES/zsh/external/*; do
    source "$file"
done

