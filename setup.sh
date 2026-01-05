#!/bin/bash

# Config Repository Setup Script
# Creates symlinks from standard config locations to this repo

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

backup_and_link() {
    local source="$1"
    local target="$2"

    if [ -L "$target" ]; then
        # Already a symlink
        current_link=$(readlink -f "$target")
        if [ "$current_link" = "$source" ]; then
            info "$target already linked correctly"
            return 0
        else
            warn "$target is symlink to $current_link, removing..."
            rm "$target"
        fi
    elif [ -e "$target" ]; then
        # Exists but not a symlink - backup
        backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        warn "$target exists, backing up to $backup"
        mv "$target" "$backup"
    fi

    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"

    # Create symlink
    ln -s "$source" "$target"
    info "Linked $target -> $source"
}

echo "========================================"
echo "  Config Repository Setup"
echo "========================================"
echo ""
echo "This will create symlinks for:"
echo "  - ~/.zshrc"
echo "  - ~/.p10k.zsh"
echo "  - ~/.tmux.conf"
echo "  - ~/.config/nvim"
echo ""
echo "Source directory: $SCRIPT_DIR"
echo ""

read -p "Continue? [y/N] " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

echo ""

# ZSH
backup_and_link "$SCRIPT_DIR/zsh/.zshrc" "$HOME/.zshrc"
backup_and_link "$SCRIPT_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

# Tmux
backup_and_link "$SCRIPT_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Neovim (link entire directory)
backup_and_link "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"

echo ""

# Check for xclip (required for tmux clipboard integration)
if ! command -v xclip &> /dev/null; then
    warn "xclip is not installed (required for tmux clipboard)"
    echo "      Install with: sudo apt install xclip"
fi

echo ""
echo "========================================"
echo "  Setup Complete!"
echo "========================================"
echo ""
echo "Notes:"
echo "  - Existing configs were backed up with .backup.* extension"
echo "  - Run 'source ~/.zshrc' to reload zsh config"
echo "  - Run 'tmux source ~/.tmux.conf' to reload tmux config (if in tmux)"
echo "  - Open nvim to let Lazy.nvim install plugins"
echo ""
