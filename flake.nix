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
        home-manager.url = "github:nix-community/home-manager";
    };

    outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
        nixosConfigurations = {
            nixos = nixpkgs.lib.nixosSystem {
                modules = [
                    ./configs/coruscant/configuration.nix
                    home-manager.nixosModules.home-manager {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.extraSpecialArgs = { inherit inputs; };
                        home-manager.users.mason = ./configs/users/mason.nix;
                    }
                ];
            };
            coruscant = nixpkgs.lib.nixosSystem {
                modules = [ ./configs/machines/coruscant/configuration.nix ];
            };
            coruscant-minimal = nixpkgs.lib.nixosSystem {
                modules = [ ./configs/machines/coruscant-minimal/configuration.nix ];
            };
        };
        homeConfigurations."mason" = home-manager.lib.homeManagerConfiguration {
	    pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [ ./configs/wsl/home.nix ];
        };
    };
}
