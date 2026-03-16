# dotfiles

Personal dev environment configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Tools Overview

| Tool | Purpose |
|------|---------|
| Zsh | Shell with Zinit plugin manager |
| Starship | Cross-shell prompt |
| Tmux | Terminal multiplexer |
| Ghostty | GPU-accelerated terminal emulator |
| Doom Emacs | Emacs distribution with evil bindings |
| LazyGit | Terminal UI for Git |
| FZF | Fuzzy finder |

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/)
- [Homebrew](https://brew.sh/) (macOS)
- The tools you want to configure: Ghostty, Tmux, Doom Emacs, LazyGit, etc.

## Installation

```bash
git clone git@github.com:mrbarboza/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow zsh ghostty starship tmux doom lazygit
```

- Stow symlinks everything into `~/.config/` (configured via `.stowrc`)
- Tmux plugins are excluded from stow (see `.stowrc`) — TPM must be installed separately (see below)

## Per-tool Configuration

### Zsh

- **Plugin manager:** [Zinit](https://github.com/zdharma-continuum/zinit)
- **Plugins:** syntax highlighting, autosuggestions, fzf-tab, completions
- **Key aliases:**
  - `v` → `nvim`
  - `e` → `emacs -nw`
- **Keybindings:** `Ctrl+P` / `Ctrl+N` for history navigation

### Starship

- Shows: directory (2 levels), git branch, git status
- Custom cyan prompt character (`❯`)

### Tmux

- **Prefix:** `Ctrl+A`
- **Pane navigation:** vim-style (`h`, `j`, `k`, `l`)
- **Floating window:** `prefix + p` (floax)
- **Plugins (via TPM):**
  - `catppuccin` — theme
  - `sessionx` — session manager
  - `floax` — floating windows
  - `continuum` + `resurrect` — session persistence
  - `fzf` — fuzzy finder integration
  - `thumbs` — hint-based text copying
  - `yank` — clipboard integration
  - `fzf-url` — open URLs with fzf
  - `sensible` — sensible defaults

### Ghostty

- **Theme:** Catppuccin Mocha
- **Font size:** 19
- **Background blur:** 20
- Borderless window, `Option` key as `Alt`

### Doom Emacs

- **Theme:** Tokyo Night
- **Font:** JetBrains Mono 15pt
- **Bindings:** Evil (Vim-style)
- **Features:** corfu completion, Magit, vterm
- **Config style:** Literate config via `config.org`

### LazyGit

- Uses [Delta](https://github.com/dandavison/delta) for diffs

## Tmux Plugin Setup

After stowing, install TPM and load plugins:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Then inside a tmux session, press `prefix + I` to install all plugins.
