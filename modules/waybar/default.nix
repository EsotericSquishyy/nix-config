# Waybar - Wayland bar
{ pkgs, pkgs-unstable, lib, config, ...}: {
    options.waybarModule = {
        enable = lib.mkEnableOption "enables waybarModule";
    };

    config = lib.mkIf config.waybarModule.enable {
        home.packages = (with pkgs; [
            # stable packages
        ]) ++ (with pkgs-unstable; [
            # unstable packages here
        ]);

        home.file.".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/waybar";

        # programs.waybar = {
        #     enable = true;
        #     style = ./style.css;
        # };
        # xdg.configFile."waybar/config".source = ./config;
    };
}
