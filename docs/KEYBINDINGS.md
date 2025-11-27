# Keyboard Shortcuts

Complete reference for all i3 keyboard shortcuts.

> **Note**: `$mod` is the Super/Windows key (Mod4)

## Window Management

| Shortcut | Action |
|----------|--------|
| `$mod+Return` | Open Kitty terminal |
| `$mod+Shift+q` | Kill focused window |
| `$mod+f` | Toggle fullscreen |
| `$mod+Shift+space` | Toggle floating mode |
| `$mod+space` | Toggle focus between tiling/floating |
| `$mod+a` | Focus parent container |

## Application Launchers

| Shortcut | Action |
|----------|--------|
| `$mod+d` | Open dmenu (application launcher) |

## Navigation

### Focus Movement
| Shortcut | Action |
|----------|--------|
| `$mod+j` | Focus left |
| `$mod+k` | Focus down |
| `$mod+l` | Focus up |
| `$mod+;` | Focus right |
| `$mod+Left` | Focus left |
| `$mod+Down` | Focus down |
| `$mod+Up` | Focus up |
| `$mod+Right` | Focus right |

### Window Movement
| Shortcut | Action |
|----------|--------|
| `$mod+Shift+j` | Move window left |
| `$mod+Shift+k` | Move window down |
| `$mod+Shift+l` | Move window up |
| `$mod+Shift+;` | Move window right |
| `$mod+Shift+Left` | Move window left |
| `$mod+Shift+Down` | Move window down |
| `$mod+Shift+Up` | Move window up |
| `$mod+Shift+Right` | Move window right |

## Layout

| Shortcut | Action |
|----------|--------|
| `$mod+h` | Split horizontal |
| `$mod+v` | Split vertical |
| `$mod+s` | Stacking layout |
| `$mod+w` | Tabbed layout |
| `$mod+e` | Toggle split layout |

## Workspaces

### Switch Workspace
| Shortcut | Action |
|----------|--------|
| `$mod+1` | Switch to workspace 1 |
| `$mod+2` | Switch to workspace 2 |
| `$mod+3` | Switch to workspace 3 |
| `$mod+4` | Switch to workspace 4 |
| `$mod+5` | Switch to workspace 5 |
| `$mod+6` | Switch to workspace 6 |
| `$mod+7` | Switch to workspace 7 |
| `$mod+8` | Switch to workspace 8 |
| `$mod+9` | Switch to workspace 9 |
| `$mod+0` | Switch to workspace 10 |

### Move Window to Workspace
| Shortcut | Action |
|----------|--------|
| `$mod+Shift+1` | Move to workspace 1 |
| `$mod+Shift+2` | Move to workspace 2 |
| `$mod+Shift+3` | Move to workspace 3 |
| `$mod+Shift+4` | Move to workspace 4 |
| `$mod+Shift+5` | Move to workspace 5 |
| `$mod+Shift+6` | Move to workspace 6 |
| `$mod+Shift+7` | Move to workspace 7 |
| `$mod+Shift+8` | Move to workspace 8 |
| `$mod+Shift+9` | Move to workspace 9 |
| `$mod+Shift+0` | Move to workspace 10 |

## Resize Mode

Enter resize mode with `$mod+r`, then:

| Shortcut | Action |
|----------|--------|
| `j` / `Left` | Shrink width |
| `k` / `Down` | Grow height |
| `l` / `Up` | Shrink height |
| `;` / `Right` | Grow width |
| `Return` | Exit resize mode |
| `Escape` | Exit resize mode |
| `$mod+r` | Exit resize mode |

## System

| Shortcut | Action |
|----------|--------|
| `$mod+Shift+c` | Reload i3 config |
| `$mod+Shift+r` | Restart i3 in-place |
| `$mod+Shift+e` | Exit i3 (with confirmation) |

## Media Keys

| Key | Action |
|-----|--------|
| `XF86AudioRaiseVolume` | Volume up 10% |
| `XF86AudioLowerVolume` | Volume down 10% |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioMicMute` | Toggle microphone mute |

## Custom Shortcuts

| Shortcut | Action |
|----------|--------|
| `Alt+Shift+4` | Screenshot area selection (saves to ~/Pictures/Screenshots) |
| `$mod+Shift+d` | Manual display switch (run i3-display-switch.sh) |

## Disabled Shortcuts

These shortcuts are commented out in the config:

| Shortcut | Action | Reason |
|----------|--------|--------|
| `$mod+d` | Focus child | Conflicts with dmenu |
| `$mod+d` | Rofi launcher | Using dmenu instead |
| `$mod+d` | i3-dmenu-desktop | Using dmenu instead |

## Customization

To modify shortcuts, edit `~/.config/i3/config`:

```bash
# Example: Change terminal to alacritty
bindsym $mod+Return exec alacritty

# Example: Add rofi instead of dmenu
bindsym $mod+d exec --no-startup-id rofi -show drun
```

After changes, reload i3:
- `$mod+Shift+c` to reload config
- `$mod+Shift+r` to restart i3
