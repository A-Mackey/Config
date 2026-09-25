# Dotfiles

Personal configuration files for zsh, tmux, and neovim.

## Contents

| Config | Description |
|--------|-------------|
| `zsh/` | Zsh config with oh-my-zsh, Powerlevel10k theme and config |
| `tmux/` | Tmux config with vim-style navigation (Ctrl-Space prefix) |
| `nvim/` | Neovim config with Lazy.nvim, Treesitter, Telescope, LSP |
| `x11/`  | X11 session config (`.xprofile`); remaps Caps Lock to Backspace |
| `gnome/` | Rectangle-style window snapping extension + GNOME keybinding tweaks |

## Installation

```bash
git clone https://github.com/AidanMackey/AidanMackey-Config.git
cd AidanMackey-Config
./setup.sh
```

The setup script creates symlinks and backs up any existing configs.

## Dependencies

- **zsh**: [oh-my-zsh](https://ohmyz.sh/), [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- **tmux**: tmux 3.0+
- **nvim**: Neovim 0.9+, [nvm](https://github.com/nvm-sh/nvm) (for Node.js LSPs)
- **gnome**: GNOME Shell 45-48, `glib-compile-schemas` (`libglib2.0-dev-bin`)

## Key Bindings

### Tmux
- `Ctrl-Space` - Prefix
- `Alt-hjkl` - Navigate panes
- `Alt-Shift-HJKL` - Resize panes
- `prefix + |` - Split horizontal
- `prefix + -` - Split vertical

### GNOME window snapping (Rectangle Snap)

[Rectangle](https://rectangleapp.com/)-style snapping on `Ctrl+Super`. Windows
stay floating and draggable; snapping only happens on keypress.

| Shortcut | Action |
|----------|--------|
| `Ctrl+Super+←/→` or `H/L` | Left / right half — repeat to step to the next monitor |
| `Ctrl+Super+↑/↓` | Top / bottom half — repeat to step to the next monitor |
| `Ctrl+Super+U/I` | Top-left / top-right quarter |
| `Ctrl+Super+J/K` | Bottom-left / bottom-right quarter |
| `Ctrl+Super+D/F/G` | Left / middle / right third |
| `Ctrl+Super+E/T` | Left / right two-thirds — repeat to flip to the other side |
| `Ctrl+Super+Return` | Maximize to work area |
| `Ctrl+Super+C` | Center (keeps current size) |

Halves treat every monitor as two panes side by side. With two monitors,
`Ctrl+Super+←` walks a window through right-monitor right half → right-monitor
left half → left-monitor right half → left-monitor left half, then stops.
Move any window between monitors unchanged with GNOME's `Super+Shift+←/→`.

Rebind via `dconf` under `/org/gnome/shell/extensions/rectangle-snap/`;
defaults live in the extension's gschema XML.

**Conflicts cleared** (restored by `setup.sh` from `gnome/dconf/`):

| Binding | Change |
|---------|--------|
| `Ctrl+Super+D` — show desktop | Removed; `Super+D` and `Ctrl+Alt+D` still work |
| `Ctrl+Super+U/I/J/K/Return` — Tiling Assistant | Unbound (Rectangle Snap owns them) |
| Terminal | `Ctrl+Alt+T` plus `Super+Return` |
| Switch workspace | `Ctrl+Alt+arrows` plus `Super+Alt+arrows`, `Super+Page_Up/Down` |

### Neovim
See `nvim/lua/keybindings.lua` for full mappings.
