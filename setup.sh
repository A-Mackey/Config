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

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k theme if not present
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    info "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# ZSH
backup_and_link "$SCRIPT_DIR/zsh/.zshrc" "$HOME/.zshrc"
backup_and_link "$SCRIPT_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

# Tmux
backup_and_link "$SCRIPT_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Install TPM (Tmux Plugin Manager) if not present
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    info "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# Neovim (link entire directory)
backup_and_link "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"

echo ""

# Check for xclip (required for tmux clipboard integration)
if ! command -v xclip &> /dev/null; then
    warn "xclip is not installed (required for tmux clipboard)"
    echo "      Install with: sudo apt install xclip"
fi

# Check for en_US.UTF-8 locale
if ! locale -a 2>/dev/null | grep -q "en_US.utf8"; then
    warn "en_US.UTF-8 locale is not generated"
    echo "      Run: sudo locale-gen en_US.UTF-8 && sudo update-locale"
fi

# Ensure zsh is the default shell
if command -v zsh &> /dev/null; then
    ZSH_PATH=$(command -v zsh)
    if [ "$SHELL" != "$ZSH_PATH" ]; then
        info "Setting zsh as the default shell..."
        chsh -s "$ZSH_PATH"
        info "Default shell changed to zsh (will take effect on next login)"
    else
        info "zsh is already the default shell"
    fi
else
    warn "zsh is not installed"
    echo "      Install with: sudo apt install zsh"
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
echo "  - Press prefix + I in tmux to install plugins (Nord theme)"
echo "  - Open nvim to let Lazy.nvim install plugins"
echo ""
