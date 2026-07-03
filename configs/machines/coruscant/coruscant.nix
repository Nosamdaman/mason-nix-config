# This file defines the full Coruscant configuration as a NixOS system. It works by defining a function which takes in
# both nixpkgs and home-manager as inputs and builds up the configuration from there.
inputs@{ nixpkgs, home-manager, ... }: nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mason = ../../users/sway.nix;
        }
    ];
}
