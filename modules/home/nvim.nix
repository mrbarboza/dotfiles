{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Extra packages available inside Neovim (for plugins that shell out)
    extraPackages = with pkgs; [
      # Already in home.packages, but listed for clarity
      ripgrep
      fd
      lazygit
      gh
    ];
  };

  # LazyVim starter layout managed via XDG config.
  # On first launch, LazyVim will bootstrap plugins.
  # We keep the config in-repo so it is versioned and pure.
  xdg.configFile."nvim" = {
    source = ../../config/nvim;
    recursive = true;
  };
}
