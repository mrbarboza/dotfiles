#!/usr/bin/env bash
# Fresh-machine bootstrap for MacBook Neo
# Usage: curl -fsSL https://raw.githubusercontent.com/mrbarboza/dotfiles/grok/bootstrap.sh | bash
# Or:    ./bootstrap.sh
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/mrbarboza/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
HOSTNAME="${HOSTNAME:-neo}"
BRANCH="${BRANCH:-grok}"

echo "==> Dotfiles bootstrap starting..."

# ─── 1. Xcode CLT (needed by Nix & Homebrew) ────────────────────────────────
if ! xcode-select -p &>/dev/null; then
  echo "==> Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "    Finish the GUI installer, then re-run this script."
  exit 1
fi

# ─── 2. Nix (Determinate Systems installer preferred) ───────────────────────
if ! command -v nix &>/dev/null; then
  echo "==> Installing Nix (Determinate Systems)..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  # shellcheck source=/dev/null
  if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
else
  echo "==> Nix already installed"
fi

# Ensure flakes are available
mkdir -p "$HOME/.config/nix"
if ! grep -q "experimental-features" "$HOME/.config/nix/nix.conf" 2>/dev/null; then
  echo "experimental-features = nix-command flakes" >> "$HOME/.config/nix/nix.conf"
fi

# ─── 3. Clone the repo ──────────────────────────────────────────────────────
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "==> Cloning dotfiles → $DOTFILES_DIR (branch $BRANCH)"
  git clone --branch "$BRANCH" "$REPO_URL" "$DOTFILES_DIR"
else
  echo "==> Dotfiles already present at $DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# ─── 4. First activation ────────────────────────────────────────────────────
echo "==> Building and switching to configuration..."
echo "    (You will be prompted for your password)"

# First-time: use nix run to get darwin-rebuild
nix --extra-experimental-features "nix-command flakes" \
  run nix-darwin -- switch --flake "$DOTFILES_DIR#$HOSTNAME"

echo ""
echo "==> Bootstrap complete."
echo "    Day-to-day:  cd $DOTFILES_DIR && just switch"
echo "    Unlock secrets: bw login && bw-unlock"
echo "    Open a new terminal (WezTerm) to pick up Fish + theme."
