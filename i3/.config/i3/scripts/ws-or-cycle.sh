#!/bin/bash
ws="$1"
current=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

if [ "$current" = "$ws" ]; then
    # Get all window IDs in current workspace
    windows=$(i3-msg -t get_tree | jq -r ".. | select(.type?==\"workspace\" and .name==\"$ws\") | .. | select(.window? != null) | .id")
    win_count=$(echo "$windows" | wc -l)
    
    if [ "$win_count" -le 1 ]; then
        exit 0
    fi
    
    # Get focused window ID
    focused=$(i3-msg -t get_tree | jq -r ".. | select(.focused? == true and .window? != null) | .id")
    
    # Find next window (wrap to first if at end)
    next=""
    found=0
    for w in $windows; do
        if [ "$found" -eq 1 ]; then
            next=$w
            break
        fi
        [ "$w" = "$focused" ] && found=1
    done
    
    # Wrap to first window if at end
    [ -z "$next" ] && next=$(echo "$windows" | head -1)
    
    i3-msg "[con_id=$next] focus" >/dev/null 2>&1
else
    i3-msg "workspace number $ws"
fi
