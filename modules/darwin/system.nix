{ pkgs, ... }:
{
  # Nix settings
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Keep builds lean on 8 GB RAM machines
      max-jobs = 4;
      cores = 0;
      # Substituters (optional speed-up)
      substituters = [
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
    # Automatically garbage-collect old generations
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 3;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
  };

  # Allow unfree packages (needed for some tools)
  nixpkgs.config.allowUnfree = true;

  # System packages available to all users
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    just
  ];

  # Enable Fish at the system level so it can be set as login shell
  programs.fish.enable = true;

  # macOS defaults (sensible starting set)
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 42;
      minimize-to-application = true;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv"; # Column view
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      "com.apple.swipescrolldirection" = false; # natural scroll off
      ApplePressAndHoldEnabled = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };

    CustomUserPreferences = {
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };
  };

  # Keyboard
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  # Fonts (JetBrainsMono Nerd Font is also pulled in via home-manager)
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
