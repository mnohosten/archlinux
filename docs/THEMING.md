# Theming & Colors

Documentation for the color schemes and visual configuration.

## Color Schemes

This setup uses two complementary color schemes:

### Monokai Pro (Terminal & Editors)

Used in: Kitty, Xresources, shell LS_COLORS

```
Background:      #2d2a2e
Foreground:      #fcfcfa

Black:           #403e41 / #727072
Red:             #ff6188
Green:           #a9dc76
Yellow:          #ffd866
Blue (Orange):   #fc9867
Magenta:         #ab9df2
Cyan:            #78dce8
White:           #fcfcfa
```

### One Dark Pro (i3 Window Manager)

Used in: i3, window borders, bar

```
Background:      #282c34
Inactive BG:     #21252b
Text:            #abb2bf
Inactive Text:   #5c6370
Urgent:          #e06c75
Indicator:       #98c379
Yellow:          #e5c07b
Blue:            #61afef
Cyan:            #56b6c2
Purple:          #c678dd
```

### SynthWave '84 (i3status Bar)

Used in: Status bar colors

```
Good:            #72f1b8 (cyan-green)
Degraded:        #fee440 (yellow)
Bad:             #ff007c (pink-red)
```

## Configuration Files

### Kitty Terminal (`kitty/.config/kitty/kitty.conf`)

```conf
# Monokai Pro colors
foreground #fcfcfa
background #2d2a2e

color0  #403e41
color1  #ff6188
color2  #a9dc76
color3  #ffd866
color4  #fc9867
color5  #ab9df2
color6  #78dce8
color7  #fcfcfa
# ... (color8-15 same as color0-7)

# Font
font_family      Cascadia Code NF
font_size        11.0

# Transparency
background_opacity 0.90
```

### X Resources (`xresources/.Xresources`)

```xdefaults
! Monokai Pro colors
*.foreground:   #fcfcfa
*.background:   #2d2a2e

! Font
*.font: xft:Cascadia Code:size=11:antialias=true
```

### i3 Window Manager (`i3/.config/i3/config`)

```conf
# One Dark Pro colors
set $bg-color            #282c34
set $inactive-bg-color   #21252b
set $text-color          #abb2bf
set $inactive-text-color #5c6370
set $urgent-bg-color     #e06c75
set $blue                #61afef
set $cyan                #56b6c2

# Window borders
client.focused          $blue $bg-color $text-color $cyan
client.unfocused        $inactive-bg-color $inactive-bg-color $inactive-text-color
client.urgent           $urgent-bg-color $urgent-bg-color $text-color
```

### i3status Bar (`i3status/.config/i3status/config`)

```conf
general {
    color_good = "#72f1b8"
    color_degraded = "#fee440"
    color_bad = "#ff007c"
}
```

## Fonts

### Primary Font: Cascadia Code

Microsoft's coding font with:
- Programming ligatures
- Nerd Font icons (NF variant)
- Powerline symbols

Used in:
- Kitty terminal (Cascadia Code NF)
- i3 window titles
- i3 status bar
- X terminals (via Xresources)

### Emoji Support: Noto Color Emoji

Google's color emoji font for full emoji rendering in:
- Terminal
- Status bar
- Window titles

### Font Configuration

Bar font in i3:
```conf
bar {
    font pango:Cascadia Code, Noto Color Emoji 10
}
```

Window title font:
```conf
font pango:Cascadia Code 10
```

## Transparency

### Kitty Terminal
```conf
background_opacity 0.90
dynamic_background_opacity yes
```

Keyboard shortcuts (when dynamic is enabled):
- `Ctrl+Shift+A > M` - Increase opacity
- `Ctrl+Shift+A > L` - Decrease opacity

### Picom Compositor (`picom/.config/picom/picom.conf`)

Handles transparency for X11 windows:
```conf
opacity-rule = [
    "90:class_g = 'kitty'"
];
```

## Customization

### Change Terminal Colors

Edit `kitty/.config/kitty/kitty.conf`:
```conf
# Example: Dracula theme
foreground #f8f8f2
background #282a36
color0  #000000
color1  #ff5555
# ...
```

### Change i3 Colors

Edit `i3/.config/i3/config`:
```conf
# Example: Nord theme
set $bg-color            #2e3440
set $text-color          #eceff4
set $blue                #5e81ac
# ...
```

### Change Status Bar Colors

Edit `i3status/.config/i3status/config`:
```conf
general {
    color_good = "#a3be8c"
    color_degraded = "#ebcb8b"
    color_bad = "#bf616a"
}
```

### Popular Theme Resources

- [Gogh](https://gogh-co.github.io/Gogh/) - Terminal color schemes
- [terminal.sexy](https://terminal.sexy/) - Terminal color designer
- [i3-style](https://github.com/altdesktop/i3-style) - i3 theme generator
