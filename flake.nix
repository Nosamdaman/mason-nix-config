# Primary entry-point for my NixOS and Home-Manager configurations
#
# This repository uses the expermental flake feature in nix in order to achieve repeatable, stable builds. Flakes are a
# little confusing at first, so I'll try to explain this as best as I can.
#
# Fundamentally, a flake is just a special standard for representing nix expresions. A flake is defined as a directory
# containing two files: flake.nix and flake.lock. The flake.nix file is what actually defines the nix expression that
# flake defines, while flake.lock is a lock file used to pin any flakes that the flake being defined relies on. This is
# what ensures that flakes can be repeatably constructed everytime.
{
    description = "Mason's NixOS and Home-Manager configurations";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
        nixosConfigurations = {
            coruscant = import ./configs/machines/coruscant/coruscant.nix inputs;
            coruscant-minimal = nixpkgs.lib.nixosSystem {
                modules = [ ./configs/machines/coruscant-minimal/configuration.nix ];
            };
        };
    };
}
