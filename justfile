# Dotfiles day-to-day commands
# Usage: just <recipe>

hostname := "neo"
flake := justfile_directory()

# Default: show help
default:
    @just --list

# Apply the configuration (requires sudo for system parts)
switch:
    darwin-rebuild switch --flake {{flake}}#{{hostname}}

# Build without activating (dry run / CI)
build:
    darwin-rebuild build --flake {{flake}}#{{hostname}}

# Update all flake inputs
update:
    nix flake update --flake {{flake}}

# Update + switch
upgrade: update switch

# Run flake checks
check:
    nix flake check {{flake}}

# Format all Nix files
fmt:
    nix fmt {{flake}}

# Garbage-collect old generations and store paths
clean:
    nix-collect-garbage -d
    sudo nix-collect-garbage -d

# Open a shell with the flake's tools
shell:
    nix develop {{flake}}

# Show current system generation
generations:
    darwin-rebuild --list-generations
