{
  config,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./packages.nix
    ./fish.nix
    ./wezterm.nix
    ./tmux.nix
    ./nvim.nix
    ./git.nix
    ./theme.nix
    ./secrets.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    stateVersion = "25.11"; # Bump when you intentionally migrate

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERM = "wezterm";
      # Bitwarden session helper (see secrets.nix)
      BW_SESSION = ""; # populated at runtime by shell function
    };

    # XDG is the modern default on macOS with home-manager
    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # direnv for per-project flakes
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # XDG directories
  xdg.enable = true;
}
