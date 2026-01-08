#!/bin/bash
# Toggle focus between tiling/floating, or show scratchpad if no floating windows

# Get current workspace name
ws=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

# Check if there are visible floating windows (not in scratchpad) in current workspace
has_floating=$(i3-msg -t get_tree | jq -r --arg ws "$ws" '
  recurse(.nodes[]?, .floating_nodes[]?) |
  select(.type=="workspace" and .name==$ws) |
  .floating_nodes[] |
  select(.scratchpad_state=="none") |
  .id
' 2>/dev/null | head -1)

if [ -n "$has_floating" ]; then
    i3-msg "focus mode_toggle"
else
    i3-msg "scratchpad show"
fi
