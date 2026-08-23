{ ... }:
{
  # Declarative Homebrew management via nix-darwin
  # GUI apps and anything poorly covered by nixpkgs live here.
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # remove undeclared formulae/casks
      upgrade = true;
    };

    # Taps (add only what you need)
    taps = [ ];

    # CLI formulae that are awkward or missing in nixpkgs
    brews = [
      # Example: "mas"  # Mac App Store CLI
    ];

    # GUI applications (casks)
    casks = [
      # Terminal is WezTerm via nixpkgs, but some prefer the cask:
      # "wezterm"

      # Quality-of-life
      "raycast"
      "rectangle" # or "aerospace" if you prefer tiling
      "stats" # menu-bar system monitor

      # Browsers / tools you actually use — uncomment as needed
      # "arc"
      # "firefox"
      # "visual-studio-code"
      # "obsidian"
      # "spotify"
    ];

    # Mac App Store apps (requires `mas` brew + signed-in App Store)
    # masApps = {
    #   "Xcode" = 497799835;
    # };
  };
}
