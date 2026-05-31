{
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
            coruscant-minimal = nixpkgs.lib.nixosSystem {
                modules = [
                    ./configs/machines/coruscant-minimal/configuration.nix
                ];
            };
        };
        homeConfigurations."mason" = home-manager.lib.homeManagerConfiguration {
	    pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [ ./configs/wsl/home.nix ];
        };
    };
}
