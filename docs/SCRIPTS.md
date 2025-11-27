# Custom Scripts

Documentation for custom scripts in `~/.local/bin/`.

## Overview

All scripts are located in `scripts/.local/bin/` and symlinked to `~/.local/bin/` via GNU Stow.

## Scripts

### wallpaper-rotator.sh

**Purpose:** Automatically rotates desktop wallpaper every 10 minutes.

**Location:** `~/.local/bin/wallpaper-rotator.sh`

**Usage:**
```bash
# Run manually
~/.local/bin/wallpaper-rotator.sh

# Or via systemd service (auto-started)
systemctl --user status wallpaper-rotator
```

**Configuration:**
- Wallpaper directory: `~/Pictures/Wallpapers`
- Rotation interval: 600 seconds (10 minutes)
- Supported formats: `.jpg`, `.jpeg`, `.png`

**Dependencies:** `feh`

**How it works:**
1. Scans `~/Pictures/Wallpapers` for images
2. Selects a random image
3. Sets it as wallpaper using `feh --bg-scale`
4. Sleeps for 10 minutes
5. Repeats

---

### screenshot-area

**Purpose:** Take screenshot of selected area and copy to clipboard.

**Location:** `~/.local/bin/screenshot-area`

**Shortcut:** `Alt+Shift+4`

**Usage:**
```bash
~/.local/bin/screenshot-area
```

**What it does:**
1. Activates area selection cursor
2. Saves screenshot to `~/Pictures/Screenshots/screenshot_TIMESTAMP.png`
3. Copies image to clipboard

**Dependencies:** `maim`, `slop`, `xclip`

---

### i3-display-switch.sh

**Purpose:** Automatically configure displays based on connected monitors.

**Location:** `~/.local/bin/i3-display-switch.sh`

**Shortcut:** `$mod+Shift+d`

**Usage:**
```bash
~/.local/bin/i3-display-switch.sh
```

**What it does:**
1. Detects connected displays
2. Checks laptop lid state
3. Configures xrandr appropriately:
   - External only (lid closed)
   - External + laptop (lid open)
   - Laptop only (no external)
4. Moves i3 workspaces to primary display
5. Logs to `/tmp/i3-display-switch.log`

**Dependencies:** `xrandr`, `i3-msg`

---

### i3-consolidate-workspaces.sh

**Purpose:** Move all workspaces to laptop display when external monitors disconnect.

**Location:** `~/.local/bin/i3-consolidate-workspaces.sh`

**Usage:**
```bash
~/.local/bin/i3-consolidate-workspaces.sh
```

**Triggered by:** autorandr postswitch hooks

**What it does:**
1. Detects active displays
2. Moves all workspaces to laptop output
3. Restarts i3 for clean state
4. Logs to `/tmp/i3-workspace-consolidate.log`

**Dependencies:** `xrandr`, `i3-msg`

---

### i3-display-handler.sh

**Purpose:** udev event handler for display hotplug events.

**Location:** `~/.local/bin/i3-display-handler.sh`

**Usage:** Called by udev rules (not manually)

**Configuration Required:**
```bash
# Edit and replace <YOUR_USERNAME>
vim ~/.local/bin/i3-display-handler.sh
```

**What it does:**
1. Sets up X11 environment variables
2. Finds i3 socket
3. Calls i3-display-switch.sh as the user

**Note:** This script runs as root via udev and switches to your user.

---

### claude-desktop

**Purpose:** Launch Claude AI web interface as a standalone app.

**Location:** `~/.local/bin/claude-desktop`

**Usage:**
```bash
claude-desktop
```

**What it does:**
Opens `https://claude.ai` in Chrome with `--app` flag (PWA-style window).

**Dependencies:** `google-chrome`

---

### whatsapp-web

**Purpose:** Launch WhatsApp Web as a standalone app.

**Location:** `~/.local/bin/whatsapp-web`

**Usage:**
```bash
whatsapp-web
```

**What it does:**
Opens `https://web.whatsapp.com` in Chrome with `--app` flag.

**Dependencies:** `google-chrome`

---

## Systemd Services

### wallpaper-rotator.service

**Location:** `~/.config/systemd/user/wallpaper-rotator.service`

**Commands:**
```bash
# Enable (start on login)
systemctl --user enable wallpaper-rotator

# Start now
systemctl --user start wallpaper-rotator

# Check status
systemctl --user status wallpaper-rotator

# View logs
journalctl --user -u wallpaper-rotator
```

---

### autorandr.service

**Location:** `~/.config/systemd/user/autorandr.service`

**Purpose:** Automatically detect and apply display profiles on login.

**Commands:**
```bash
# Enable
systemctl --user enable autorandr

# Check status
systemctl --user status autorandr
```

---

## Adding New Scripts

1. Create script in `scripts/.local/bin/`:
```bash
vim ~/dotfiles/scripts/.local/bin/my-script.sh
chmod +x ~/dotfiles/scripts/.local/bin/my-script.sh
```

2. Re-stow to create symlink:
```bash
cd ~/dotfiles
stow -t ~ --restow scripts
```

3. (Optional) Add i3 keybinding:
```conf
# In ~/.config/i3/config
bindsym $mod+x exec --no-startup-id ~/.local/bin/my-script.sh
```
