{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Core CLI
    bat
    eza
    fd
    fzf
    ripgrep
    jq
    yq-go
    tree
    htop
    btop
    dust
    delta
    zoxide
    starship # optional prompt; Fish can use its own

    # Git / GitHub
    gh
    lazygit
    git-lfs

    # Editor ecosystem / LSPs (global)
    # Language servers you want everywhere; project-specific ones stay in flakes
    nil # Nix LSP
    nixpkgs-fmt
    lua-language-server
    stylua
    nodePackages.typescript-language-server
    nodePackages.prettier
    gopls
    rust-analyzer
    pyright
    ruff

    # Multiplexer / terminal helpers
    tmux
    sesh # optional session manager

    # Secrets
    bitwarden-cli

    # Fonts (also declared at system level for completeness)
    nerd-fonts.jetbrains-mono

    # Misc quality-of-life
    just
    watchexec
    glow # markdown
    tldr
  ];
}
