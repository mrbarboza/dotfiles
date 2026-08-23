{
  description = "Dotfiles — MacBook Neo (nix-darwin + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      # Change these for your machine / user
      username = "neo";
      hostname = "neo";
      system = "aarch64-darwin"; # Apple Silicon. Use x86_64-darwin for Intel.

      specialArgs = {
        inherit inputs username hostname;
      };
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system specialArgs;
        modules = [
          ./hosts/${hostname}
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              users.${username} = import ./modules/home;
            };
          }
        ];
      };

      # Convenience: expose the system for `nix build .#darwinConfigurations.neo.system`
      packages.${system}.default = self.darwinConfigurations.${hostname}.system;

      # Formatter
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
    };
}
