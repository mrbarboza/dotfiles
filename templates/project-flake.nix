# Template for per-project toolchains.
# Copy into a project repo as flake.nix, then:
#   echo 'use flake' > .envrc && direnv allow
#
# This keeps build toolchains (Go, Rust, Node, Python, etc.)
# out of the global home-manager environment.

{
  description = "Project toolchain";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # --- pick what you need ---
            # Go
            # go
            # gopls

            # Rust
            # rustc
            # cargo
            # rust-analyzer
            # rustfmt
            # clippy

            # Node / TypeScript
            # nodejs_22
            # pnpm
            # typescript

            # Python
            # python312
            # uv
            # ruff
            # pyright

            # Common
            just
            git
          ];

          shellHook = ''
            echo "Entered project devShell"
          '';
        };
      }
    );
}
