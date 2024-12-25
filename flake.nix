{
    description = "Squishyy's NixOS Config";

    inputs = {
        # Nixpkgs
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        # Home manager
        home-manager = {
            url = "github:nix-community/home-manager/release-24.11";
            # url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprland.url = "github:hyprwm/Hyprland";

        nixvim = {
            url = "github:nix-community/nixvim/nixos-24.11";
            # url = "github:nix-community/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # hardware.url = "github:nixos/nixos-hardware";

        nix-colors.url = "github:misterio77/nix-colors";

        # kmonad = {
        #     url = "github:kmonad/kmonad?dir=nix";
        #     inputs.nixpkgs.follows = "nixpkgs";
        # };

        # https://aylur.github.io/ags-docs/
        # ags.url = "github:Aylur/ags"; # Eww alternative
    };

    outputs = {
        self,
        nixpkgs,
        nixpkgs-unstable,
        home-manager,
        hyprland,
        nixvim,
        nix-colors,
        ...
    } @ inputs:
    let
        inherit (self) outputs;
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    in {
        # NixOS configuration entrypoint
        # Available through 'nixos-rebuild --flake .#squishyy-os'
        nixosConfigurations = {
            squishyy-os = nixpkgs.lib.nixosSystem {
                specialArgs = {inherit inputs outputs;};
                modules = [
                    ./hosts/squishyy-os/configuration.nix

                    hyprland.nixosModules.default
                    {
                        programs.hyprland.enable = true;
                        programs.hyprland.xwayland.enable=true;
                    }

                    home-manager.nixosModules.home-manager
                    {
                        #home-manager.useGlobalPkgs = true;
                        #home-manager.useUserPackages = true;
                        #home-manager.users.squishyy = import ./home/squishyy/home.nix;
                        home-manager.extraSpecialArgs = { inherit inputs pkgs-unstable; };
                        home-manager.users.squishyy.imports = [
                            ./home/squishyy/home.nix
                        ];
                    }
                ];
            };
        };

        # Standalone home-manager configuration entrypoint
        # Available through 'home-manager --flake .#squishyy@squishyy-os'
        homeConfigurations = {
            "squishyy@squishyy-os" = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.${system}; # Home-manager requires 'pkgs' instance
                extraSpecialArgs = {inherit inputs outputs pkgs-unstable;};
                modules = [
                    ./home/squishyy/home.nix
                ];
            };
        };

        devShells.${system} = {
            python = pkgs.mkShell {
                # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md#buildpythonpackage-function
                nativeBuildInputs = with pkgs.buildPackages; [
                    xspim

                    (python3.withPackages (ps: with ps; with python3Packages; [
                        pandas
                        numpy
                        matplotlib
                        pwntools
                        # torch
                        flask
                        flask-limiter
                        # sklearn-deap
                        tensorflow
                        keras

                        # (buildPythonPackage rec {
                        #     pname = "pyrtl";
                        #     version = "0.10.2";
                        #     src = fetchPypi {
                        #         inherit pname version;
                        #         sha256 = "sha256-Ji2EAe/tI4hQ+n8EMm+uBkCjzXi+fSv+m17EeQ0Zysg=";
                        #     };
                        #     doCheck = false;
                        # })
                    ]))
                ];
            };

            jupyter = pkgs.mkShell {
                nativeBuildInputs = with pkgs.buildPackages; [
                    (python3.withPackages (ps: with ps; with python3Packages; [
                        jupyter
                        ipython
                        pandas
                        scipy
                        numpy
                        matplotlib
                    ]))
                ];

                shellHook = "jupyter-notebook";
            };

            rust = pkgs.mkShell {
                RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
                nativeBuildInputs = with pkgs.buildPackages; [
                    gcc

                    #rustup
                    cargo
                    rustc
                    rustfmt
                    clippy
                ];
            };

            c = pkgs.mkShell {
                nativeBuildInputs = with pkgs.buildPackages; [
                    gcc
                    clang
                ];
            };
        };
    };
}
