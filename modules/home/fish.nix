{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # Disable greeting
      set -g fish_greeting

      # Rose Pine colors (main variant)
      set -g fish_color_normal normal
      set -g fish_color_command '#c4a7e7'          # iris
      set -g fish_color_keyword '#eb6f92'          # love
      set -g fish_color_quote '#f6c177'            # gold
      set -g fish_color_redirection '#31748f'      # pine
      set -g fish_color_end '#9ccfd8'              # foam
      set -g fish_color_error '#eb6f92'            # love
      set -g fish_color_param '#e0def4'            # text
      set -g fish_color_comment '#6e6a86'          # muted
      set -g fish_color_selection --background '#26233a'  # highlight_high
      set -g fish_color_search_match --background '#26233a'
      set -g fish_color_operator '#9ccfd8'
      set -g fish_color_escape '#ebbcba'           # rose
      set -g fish_color_autosuggestion '#6e6a86'
      set -g fish_pager_color_progress '#6e6a86'
      set -g fish_pager_color_prefix '#c4a7e7'
      set -g fish_pager_color_completion '#e0def4'
      set -g fish_pager_color_description '#6e6a86'

      # zoxide
      zoxide init fish | source

      # direnv
      direnv hook fish | source

      # Bitwarden session helper (see secrets.nix)
      if test -f ~/.config/fish/functions/bw-unlock.fish
        source ~/.config/fish/functions/bw-unlock.fish
      end
    '';

    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --group-directories-first";
      la = "eza -la --icons --group-directories-first";
      tree = "eza --tree --icons";
      cat = "bat";
      g = "git";
      lg = "lazygit";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      c = "clear";
      ".." = "cd ..";
      "..." = "cd ../..";
    };

    functions = {
      # Quick rebuild
      switch-config = {
        body = ''
          darwin-rebuild switch --flake ~/dotfiles#neo
        '';
      };
    };

    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      # Alternative: pure / other prompts. Tide is popular with rose-pine.
    ];
  };

  # Make Fish the default login shell (nix-darwin also enables it)
  home.sessionVariables.SHELL = "${pkgs.fish}/bin/fish";
}
