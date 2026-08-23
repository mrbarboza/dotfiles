{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Neo";          # ← change me
    userEmail = "neo@example.com"; # ← change me

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core = {
        editor = "nvim";
        pager = "delta";
      };
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
        # Rose Pine friendly
        syntax-theme = "ansi";
      };
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      credential.helper = "osxkeychain";
    };

    aliases = {
      st = "status -sb";
      co = "checkout";
      br = "branch";
      ci = "commit";
      ca = "commit --amend";
      lg = "log --oneline --graph --decorate -20";
      last = "log -1 HEAD";
      unstage = "reset HEAD --";
    };

    ignores = [
      ".DS_Store"
      ".direnv/"
      ".envrc"
      "result"
      "result-*"
      ".idea/"
      "*.swp"
      "*~"
    ];
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  # Lazygit with Rose Pine
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          activeBorderColor = [ "#ebbcba" "bold" ]; # rose
          inactiveBorderColor = [ "#6e6a86" ];      # muted
          optionsTextColor = [ "#9ccfd8" ];         # foam
          selectedLineBgColor = [ "#26233a" ];      # highlight_high
          selectedRangeBgColor = [ "#26233a" ];
          cherryPickedCommitBgColor = [ "#31748f" ]; # pine
          cherryPickedCommitFgColor = [ "#ebbcba" ];
          unstagedChangesColor = [ "#eb6f92" ];      # love
          defaultFgColor = [ "#e0def4" ];            # text
        };
        showIcons = true;
        nerdFontsVersion = "3";
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
  };
}
