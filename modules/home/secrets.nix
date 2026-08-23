{ pkgs, ... }:
{
  # Bitwarden CLI is installed via packages.nix.
  # Nothing secret is stored in this repository.
  #
  # Workflow:
  #   1. bw login          (once)
  #   2. bw-unlock         (per session / after reboot)
  #   3. Shell functions inject GH_TOKEN etc. from BW items
  #
  # Create a secure note or login item in Bitwarden named "github-token"
  # (or whatever you prefer) and adjust the function below.

  home.file.".config/fish/functions/bw-unlock.fish".text = ''
    function bw-unlock --description "Unlock Bitwarden and export session + common tokens"
      set -l status (bw status 2>/dev/null | jq -r '.status')
      if test "$status" = "unauthenticated"
        echo "Not logged in. Run: bw login"
        return 1
      end

      if test "$status" = "locked"
        set -gx BW_SESSION (bw unlock --raw)
        if test -z "$BW_SESSION"
          echo "Unlock failed"
          return 1
        end
        echo "Bitwarden unlocked"
      else
        echo "Already unlocked"
      end

      # Example: inject GitHub token (adjust item name / field as needed)
      # set -gx GH_TOKEN (bw get password "github-token" 2>/dev/null)
      # set -gx GITHUB_TOKEN $GH_TOKEN
    end
  '';

  # Optional helper that runs on interactive shell start (commented out by default)
  # Uncomment if you want an automatic prompt on every new shell.
  # programs.fish.interactiveShellInit = lib.mkAfter ''
  #   if command -q bw
  #     # silent check; user can call bw-unlock manually
  #   end
  # '';
}
