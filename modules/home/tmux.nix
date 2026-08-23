{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    prefix = "C-a";

    extraConfig = builtins.readFile ../../config/tmux/tmux.conf;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
      {
        plugin = rose-pine;
        extraConfig = ''
          set -g @rose_pine_variant 'main'
          set -g @rose_pine_host 'on'
          set -g @rose_pine_date_time '%Y-%m-%d %H:%M'
          set -g @rose_pine_user 'on'
          set -g @rose_pine_directory 'on'
        '';
      }
    ];
  };
}
