# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal dotfiles (zsh, tmux, neovim, ghostty, clangd, X11, GNOME). There is no build, lint, or test suite. `setup.sh` is the installer. It prompts for confirmation, installs missing dependencies (oh-my-zsh, p10k, TPM, nvm/Node, plus packages through apt/dnf/yum/pacman/brew), then **symlinks** repo files into `$HOME`.

## Deployment model

- Everything is deployed by `backup_and_link` in `setup.sh`. The live config *is* the repo file, so edits take effect right away (after a reload) with no re-run. If an existing non-symlink target is in the way, it is moved to `*.backup.<timestamp>`.
- When you add a new config file, add a `backup_and_link` call **and** add it to the "This will create symlinks for" list that `setup.sh` echoes. Also update the README table.
- `nvim/` is linked as a whole directory to `~/.config/nvim`. `nvim/update.sh` (a `cp -r` into `~/.config/nvim`) and the sparse-checkout steps in `nvim/README.md` are older ways to install. Don't use them when the directory is symlinked.
- Reload after editing: `source ~/.zshrc`, `tmux source ~/.tmux.conf`, restart nvim (Lazy.nvim handles plugins, and `nvim/lazy-lock.json` pins their versions).

## Cross-file wiring

- **tmux**: `tmux/.tmux.conf` only `source-file`s `~/.tmux/conf.d/NN-*.conf`, in order. A new conf.d file must be added there by hand. The conf.d files call helper scripts through their `~/.tmux/...` paths: `20-clipboard.conf` sends every copy through `clipboard-filter.pl | xclip`, and `30-statusbar.conf` calls `sysstats.sh`. `setup.sh` symlinks each helper script individually.
- **neovim**: `init.lua` loads `options`, `plugins` (the lazy.nvim bootstrap and spec in `lua/plugins/init.lua`), and `keybindings`, then `require`s each `lua/plugins/*.lua` module to configure it. LSP servers are installed by Mason and auto-enabled by `mason-lspconfig`. The exception is `rust_analyzer`, which is excluded because rustaceanvim owns it. Per-server settings go through `vim.lsp.config(...)` in `lua/plugins/lsp.lua`.
- **clangd**: `clangd/config.yaml` exists only to put warnings back for `arduino_language_server` builds, which pass `-w`. It is scoped by `PathMatch` to that server's temp dir so normal projects aren't affected.

## GNOME Rectangle Snap extension

- The source is `gnome/extensions/rectangle-snap@aidan.local/`, an ESM GNOME Shell extension that supports shell versions 45–48. `setup.sh` symlinks it and runs `glib-compile-schemas`. `gschemas.compiled` is gitignored.
- Each snap action is a key in the `SNAPS` map in `extension.js`, and it must match a `<key name=...>` in the gschema XML, which holds the default bindings. To add an action, edit both files, recompile the schema, and log out and back in (on X11: Alt+F2 → `r`).
- `gnome/dconf/*.conf` are `dconf dump` snapshots. They move GNOME/Tiling Assistant bindings off the Ctrl+Super keys that the extension takes. `setup.sh` loads each file into a hard-coded dconf path chosen by filename. A new dump file needs a matching `case` branch there. Keep the README's keybinding tables in sync with any binding change.
