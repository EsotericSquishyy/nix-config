{
    description = "Squishyy's NixOS Config";

    inputs = {
        # Nixpkgs
        nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        # Home manager
        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # hardware.url = "github:nixos/nixos-hardware";
        # nix-colors.url = "github:misterio77/nix-colors";
    };

    outputs = {
        self,
        nixpkgs,
        home-manager,
        ...
    } @ inputs: let
        inherit (self) outputs;
        system = "x86_64-linux";
    in {
        # NixOS configuration entrypoint
        # Available through 'nixos-rebuild --flake .#squishyy-os'
        nixosConfigurations = {
            squishyy-os = nixpkgs.lib.nixosSystem {
                specialArgs = {inherit inputs outputs;};
                modules = [
                    ./nixos/configuration.nix
                    # make home-manager as a module of nixos
                    # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
                    home-manager.nixosModules.home-manager {
                        #home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;

                        home-manager.users.squishyy = import ./home-manager/home.nix;

                        # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
                    }
                ];
            };
        };

        # Standalone home-manager configuration entrypoint
        # Available through 'home-manager --flake .#squishyy@squishyy-os'
        homeConfigurations = {
            "squishyy@squishyy-os" = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
                extraSpecialArgs = {inherit inputs outputs;};
                modules = [
                    ./home-manager/home.nix
                ];
            };
        };
    };
}
