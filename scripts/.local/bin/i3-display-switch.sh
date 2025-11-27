#!/bin/bash
#
# i3 Display Switcher
# Automatically switches workspaces between laptop and external monitors
#

# Get laptop display (usually eDP-1 or eDP1, LVDS-1, etc.)
LAPTOP_DISPLAY=$(xrandr | grep -E "^(eDP|LVDS)" | grep -o "^[^ ]*" | head -n1)

# Get all connected external displays
EXTERNAL_DISPLAYS=$(xrandr | grep " connected" | grep -v "^${LAPTOP_DISPLAY}" | cut -d' ' -f1)

# Count external displays
EXTERNAL_COUNT=$(echo "$EXTERNAL_DISPLAYS" | grep -v "^$" | wc -l)

# Log for debugging (optional)
LOG_FILE="/tmp/i3-display-switch.log"
echo "[$(date)] Running display switch - Laptop: $LAPTOP_DISPLAY, External count: $EXTERNAL_COUNT" >> "$LOG_FILE"

if [ $EXTERNAL_COUNT -gt 0 ]; then
    # External monitor(s) connected
    echo "[$(date)] External monitor(s) detected: $EXTERNAL_DISPLAYS" >> "$LOG_FILE"

    # Get the first external display
    PRIMARY_EXTERNAL=$(echo "$EXTERNAL_DISPLAYS" | head -n1)

    # Configure displays: external as primary, laptop display to the right (or off if lid closed)
    xrandr --output "$PRIMARY_EXTERNAL" --auto --primary

    # Check if laptop lid is closed
    LID_STATE=$(cat /proc/acpi/button/lid/*/state 2>/dev/null | grep -o "open\|closed" || echo "open")

    if [ "$LID_STATE" = "closed" ]; then
        echo "[$(date)] Lid is closed, disabling laptop display" >> "$LOG_FILE"
        # Turn off laptop display when lid is closed
        xrandr --output "$LAPTOP_DISPLAY" --off
    else
        echo "[$(date)] Lid is open, extending to laptop display" >> "$LOG_FILE"
        # Keep laptop display active but as secondary
        xrandr --output "$LAPTOP_DISPLAY" --auto --right-of "$PRIMARY_EXTERNAL"
    fi

    # Move all workspaces to the external monitor
    for ws in $(i3-msg -t get_workspaces | jq -r '.[].name'); do
        i3-msg "[workspace=$ws] move workspace to output $PRIMARY_EXTERNAL" >> "$LOG_FILE" 2>&1
    done

else
    # No external monitors - use laptop display
    echo "[$(date)] No external monitors, using laptop display" >> "$LOG_FILE"

    xrandr --output "$LAPTOP_DISPLAY" --auto --primary

    # Disable any disconnected displays
    for display in $(xrandr | grep " disconnected" | cut -d' ' -f1); do
        xrandr --output "$display" --off
    done

    # Move all workspaces to laptop display
    for ws in $(i3-msg -t get_workspaces | jq -r '.[].name'); do
        i3-msg "[workspace=$ws] move workspace to output $LAPTOP_DISPLAY" >> "$LOG_FILE" 2>&1
    done
fi

# Restart i3bar to update display
i3-msg restart

echo "[$(date)] Display switch complete" >> "$LOG_FILE"
