# dotfiles

Personal dev environment configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Tools Overview

| Tool | Purpose |
|------|---------|
| Zsh | Shell with Zinit plugin manager |
| Starship | Cross-shell prompt |
| Tmux | Terminal multiplexer |
| Herdr | Mouse-first agent multiplexer |
| Ghostty | GPU-accelerated terminal emulator |
| Doom Emacs | Emacs distribution with evil bindings |
| LazyGit | Terminal UI for Git |
| FZF | Fuzzy finder |
| WezTerm | GPU-accelerated terminal emulator |
| Neovim | LazyVim-based editor with Clojure and Python support |

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/)
- [Homebrew](https://brew.sh/) (macOS)
- The tools you want to configure: Ghostty, Tmux, Doom Emacs, LazyGit, etc.

## Installation

```bash
git clone git@github.com:mrbarboza/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow zsh ghostty starship tmux herdr doom lazygit wezterm nvim
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

### Herdr

Mouse-first agent multiplexer; config mirrors the tmux setup where herdr supports it.

- **Prefix:** `Ctrl+A`
- **Pane navigation:** vim-style (`h`, `j`, `k`, `l`)
- **Splits:** `prefix + v` (side-by-side), `prefix + s` (stacked)
- **Tabs:** `prefix + Shift+H` / `prefix + Shift+L` (prev/next)
- **Theme:** Catppuccin, magenta accent
- **Session restore:** agent panes resumed on restart (`resume_agents_on_restore`)
- Config lives at `~/.config/herdr/config.toml` (stowed as an individual file symlink,
  since herdr keeps runtime sockets/logs in that same directory)
- Not ported from tmux: vim-tmux-navigator passthrough, directional resize, and the TPM
  plugin stack (thumbs/fzf/yank/floax/sessionx) — herdr has its own plugin system

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

### WezTerm

- **Theme:** Catppuccin Mocha
- **Font:** JetBrains Mono 16pt
- **Background blur:** 30
- Borderless window (`RESIZE` decorations), tab bar disabled
- **Keybindings:**
  - `Ctrl+Q` → toggle fullscreen
  - `Ctrl+'` → clear scrollback
  - `Ctrl+Click` → open link under cursor

### Neovim

- **Distribution:** [LazyVim](https://www.lazyvim.org/)
- **Theme:** Catppuccin Mocha
- **Languages:** Clojure (Conjure, clojure-lsp, clj-kondo), Python (Pyright, Ruff, neotest, nvim-dap)
- **Extras:** `lang.clojure`, `lang.python`, `dap.core`, `test.core`, `lang.{git,json,markdown,sql,terraform,typescript,yaml}`
- **Plugins:** tmux-navigator for seamless pane navigation
- **Post-install:** run `:MasonInstall clojure-lsp clj-kondo` inside nvim

## Tmux Plugin Setup

After stowing, install TPM and load plugins:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Then inside a tmux session, press `prefix + I` to install all plugins.
