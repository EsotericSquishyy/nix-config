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

        hyprland.url = "github:hyprwm/Hyprland";

        # hardware.url = "github:nixos/nixos-hardware";
        # nix-colors.url = "github:misterio77/nix-colors";
    };

    outputs = {
        self,
        nixpkgs,
        home-manager,
        hyprland,
        ...
    } @ inputs:
    let
        inherit (self) outputs;
        system = "x86_64-linux";
    in {
        # NixOS configuration entrypoint
        # Available through 'nixos-rebuild --flake .#squishyy-os'
        nixosConfigurations = {
            squishyy-os = nixpkgs.lib.nixosSystem {
                specialArgs = {inherit inputs outputs;};
                modules = [
                    ./hosts/squishyy-os/configuration.nix

                    #hyprland.nixosModules.default
                    {
                        programs.hyprland.enable = true;
                        programs.hyprland.xwayland.enable=true;
                    }

                    home-manager.nixosModules.home-manager
                    {
                        #home-manager.useGlobalPkgs = true;
                        #home-manager.useUserPackages = true;

                        home-manager.users.squishyy = import ./home/squishyy/home.nix;

                        # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
                    }
                ];
            };
        };

        # Standalone home-manager configuration entrypoint
        # Available through 'home-manager --flake .#squishyy@squishyy-os'
        homeConfigurations = {
            "squishyy@squishyy-os" = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.${system}; # Home-manager requires 'pkgs' instance
                extraSpecialArgs = {inherit inputs outputs;};
                modules = [
                    ./home/squishyy/home.nix
                ];
            };
        };
    };
}
