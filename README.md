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
| Neovim | Minimal starter config; native `vim.pack`, Rose Pine Moon + transparency |

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/)
- [Homebrew](https://brew.sh/) (macOS)
- The tools you want to configure: Ghostty, Tmux, Doom Emacs, LazyGit, etc.

## Installation

```bash
git clone git@github.com:mrbarboza/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow zsh ghostty starship tmux herdr doom lazygit wezterm
stow -t ~/.config/nvim nvim
```

- Stow symlinks everything into `~/.config/` (configured via `.stowrc`)
- Neovim uses a flat package layout and is stowed with an explicit target (`~/.config/nvim`)
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

LazyVim-like stack (no Snacks) on Neovim 0.12 [`vim.pack`](https://neovim.io/doc/user/pack.html#vim.pack).

- **Theme:** Rose Pine **Moon** + transparency
- **Config:** `~/.config/nvim/init.lua` → `lua/mrbarboza/`
- **Stow:** `stow -t ~/.config/nvim nvim`
- **First run:** start `nvim` once — installs ~40 plugins, mason tools, and treesitter parsers (several minutes)

**Stack**

| Area | Plugins |
|------|---------|
| UI | which-key, bufferline, lualine, noice, nvim-notify, mini.icons |
| Editor | oil, telescope, harpoon, trouble, todo-comments |
| LSP | mason, lspconfig, conform, nvim-lint, nvim-cmp |
| Editing | mini.pairs, mini.comment, mini.surround, yanky |
| Git | gitsigns, lazygit |
| Lang | Python, TypeScript (vtsls), Markdown, YAML, Docker |

**Keymaps (highlights)**

| Keys | Action |
|------|--------|
| `<leader>e` / `<leader>fe` | Oil explorer (root / cwd) |
| `<leader>ff` / `<leader><space>` | Find files (telescope) |
| `<leader>/` / `<leader>sg` | Live grep |
| `<leader>sk` | All keymaps (telescope) |
| `<leader>bd` / `<leader>bo` | Delete buffer / other buffers |
| `<leader>bb` | Switch to other buffer |
| `<leader>H` / `<leader>h` | Harpoon add / menu |
| `<leader>1`–`9` | Harpoon jump |
| `<leader>gg` / `<leader>gG` | LazyGit (root / cwd) |
| `<leader>gh*` | Gitsigns hunks |
| `<leader>cf` / `<leader>uf` | Format / toggle format-on-save |
| `<leader>ca` / `<leader>co` | Code action / organize imports |
| `<leader>cd` / `]d` / `[d` | Line diagnostics / jump |
| `gd` / `gr` / `K` | LSP definition / refs / hover |
| `<leader>xx` / `<leader>cS` | Trouble diagnostics / LSP symbols |
| `<leader>qs` | Restore session |
| `<leader>us` / `<leader>uw` / `<leader>uh` | Toggle spell / wrap / inlay hints |
| `<C-s>` | Save file |
| `<leader>?` | Buffer keymaps (which-key) |

Full LazyVim-style maps live in [`nvim/lua/mrbarboza/keymaps.lua`](nvim/lua/mrbarboza/keymaps.lua) and plugin modules under [`nvim/lua/mrbarboza/plugins/`](nvim/lua/mrbarboza/plugins/).

**External tools:** `lazygit`, `rg` or `fd` (telescope), `tree-sitter-cli` (Homebrew), language servers via `:Mason`

**Health / first-time setup**

```bash
brew install tree-sitter-cli
```

Mason binaries are on `PATH` via [`zsh/mrbarboza.zsh`](zsh/mrbarboza.zsh). After the first `nvim` session, run `:checkhealth` and:

- `:TSUpdate` — rebuild treesitter parsers (needs `tree-sitter` CLI)
- `:Mason` — install any missing LSPs/formatters (yamlls, dockerls, docker-compose-language-service, etc.)

Add plugins in [`nvim/lua/mrbarboza/pack.lua`](nvim/lua/mrbarboza/pack.lua); per-plugin setup lives under [`nvim/lua/mrbarboza/plugins/`](nvim/lua/mrbarboza/plugins/).

## Tmux Plugin Setup

After stowing, install TPM and load plugins:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Then inside a tmux session, press `prefix + I` to install all plugins.
