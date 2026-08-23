# Dotfiles — MacBook Neo (`grok` branch)

Hardware-agnostic **Nix + nix-darwin + home-manager** configuration.

Inspired by [omerxx/dotfiles](https://github.com/omerxx/dotfiles) and [craftzdog/dotfiles](https://github.com/craftzdog/dotfiles-public).

> This branch (`grok`) contains the full Nix rewrite of the plan. The default branch still has the previous stow-based layout.

## Stack

| Layer            | Choice                                      |
|------------------|---------------------------------------------|
| System           | nix-darwin (single flake, multi-host ready) |
| User env         | home-manager                                |
| Shell            | Fish + Tide                                 |
| Terminal         | WezTerm                                     |
| Multiplexer      | tmux (+ Rose Pine)                          |
| Editor           | LazyVim (plain, unmodified core)            |
| Git UI           | LazyGit (wired into Neovim)                 |
| GitHub CLI       | `gh`                                        |
| Font             | JetBrainsMono Nerd Font                     |
| Theme            | Rose Pine (WezTerm / nvim / tmux / Fish / LazyGit) |
| Secrets          | Bitwarden CLI only — nothing in repo        |
| GUI apps         | nix-darwin Homebrew module (casks)          |
| Project toolchains | direnv + per-project flakes               |
| Day-to-day       | `just`                                      |
| CI               | GitHub Actions (`flake check` + dry build)  |

## Quick start (fresh machine)

```bash
export REPO_URL="https://github.com/mrbarboza/dotfiles.git"
export BRANCH="grok"

curl -fsSL https://raw.githubusercontent.com/mrbarboza/dotfiles/grok/bootstrap.sh | bash
```

Or clone manually:

```bash
git clone --branch grok https://github.com/mrbarboza/dotfiles.git ~/dotfiles
cd ~/dotfiles
# edit flake.nix (username/hostname) and modules/home/git.nix first
nix run nix-darwin -- switch --flake .#neo
```

## Day-to-day

```bash
cd ~/dotfiles
just switch      # apply changes
just update      # flake update
just upgrade     # update + switch
just build       # dry build
just check       # flake check
just clean       # GC
just --list      # all recipes
```

## Repository layout

```
.
├── flake.nix                 # inputs + darwinConfigurations.neo
├── hosts/neo/                # host-specific wiring
├── modules/
│   ├── darwin/               # system, defaults, homebrew
│   └── home/                 # Fish, WezTerm, tmux, nvim, git, secrets…
├── config/                   # raw config files (Lua, tmux.conf, …)
├── templates/project-flake.nix
├── justfile
├── bootstrap.sh
└── .github/workflows/ci.yml
```

## First-time customisation

Edit these before (or right after) the first switch:

1. **`flake.nix`** — `username`, `hostname`, `system`
2. **`modules/home/git.nix`** — `userName` / `userEmail`
3. **`modules/darwin/homebrew.nix`** — add the casks you actually use

## Secrets

```bash
bw login
bw-unlock          # Fish function provided by the config
```

Nothing secret is ever committed.

## Per-project toolchains

```bash
cp ~/dotfiles/templates/project-flake.nix ./flake.nix
echo 'use flake' > .envrc
direnv allow
```

## License

MIT
