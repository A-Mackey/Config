# Dotfiles

Personal configuration files for zsh, tmux, and neovim.

## Contents

| Config | Description |
|--------|-------------|
| `zsh/` | Zsh config with oh-my-zsh and Powerlevel10k theme |
| `tmux/` | Tmux config with vim-style navigation (Ctrl-Space prefix) |
| `nvim/` | Neovim config with Lazy.nvim, Treesitter, Telescope, LSP |

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

## Key Bindings

### Tmux
- `Ctrl-Space` - Prefix
- `Alt-hjkl` - Navigate panes
- `Alt-Shift-HJKL` - Resize panes
- `prefix + |` - Split horizontal
- `prefix + -` - Split vertical

### Neovim
See `nvim/lua/keybindings.lua` for full mappings.
