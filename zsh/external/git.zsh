gli() {
  local filter
  if [ -n $@ ] && [ -f $@ ]; then
    filter="-- $@"
  fi

  git log \
    --color=always --abbrev=7 --format='%C(auto)%h%d %an %C(blue)%s %C(yellow)%cr' $@ | \
    fzf \
        --ansi --no-sort --reverse --tiebreak=index \
        --preview "f() { set -- \$(echo -- \$@ | grep -o '[a-f0-9]\{7\}'); [ \$# -eq 0 ] || git show --color=always \$1 $filter; }; f {}" \
        --bind "j:down,k:up,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,q:abort,ctrl-m:execute:
                    (grep -o '[a-f0-9]\{7\}' | head -1 |
                    xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                    {}
                    FZF-EOF" \
        --header="^f/b : navigate preview; ENTER: view" \
        --preview-window=right:60% \
}

git_file_history_diff() {
  # Ensure a file is provided as an argument
  if [ -z "$1" ]; then
    echo "Usage: git_file_history_diff <file_path>"
    return 1
  fi

  local file_path="$1"

  # Ensure the file is inside a git repository
  if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
    echo "Not a git repository"
    return 1
  fi

  # Use fzf to show commits affecting the file
  git log --pretty=format:"%h %C(bold)%s%C(reset)" --date=short -- "$file_path" | \
  fzf --height=100% --border=none --layout=reverse --preview-window=right:80%:wrap \
  --preview "echo {} | awk '{print \$1}' | xargs -I {} git show --color {} -- '$file_path'"
}
