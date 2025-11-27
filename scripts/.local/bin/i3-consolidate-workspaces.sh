#!/bin/bash
# Script to consolidate all i3 workspaces to the laptop display
# Useful when external monitors are disconnected

# Find the laptop display (usually eDP-* or LVDS-*)
LAPTOP_OUTPUT=$(i3-msg -t get_outputs | jq -r '.[] | select(.name | test("^eDP|^LVDS")) | .name' | head -1)

# If no laptop display found, try to find the first active output
if [ -z "$LAPTOP_OUTPUT" ]; then
    LAPTOP_OUTPUT=$(i3-msg -t get_outputs | jq -r '.[] | select(.active == true) | .name' | head -1)
fi

# If we still don't have an output, exit
if [ -z "$LAPTOP_OUTPUT" ]; then
    echo "Error: No active display found" >&2
    exit 1
fi

# Log for debugging
echo "[$(date)] Consolidating workspaces to $LAPTOP_OUTPUT" >> /tmp/i3-workspace-consolidate.log

# Get all workspace names and move them to the laptop display
i3-msg -t get_workspaces | jq -r '.[].name' | while read -r workspace; do
    i3-msg "workspace $workspace; move workspace to output $LAPTOP_OUTPUT" >> /tmp/i3-workspace-consolidate.log 2>&1
done

# Refresh i3
i3-msg restart >> /tmp/i3-workspace-consolidate.log 2>&1
