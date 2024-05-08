# Eww - Widgets
{ pkgs, lib, config, ...}: {

    options.ewwModule = {
        enable = lib.mkEnableOption "enables ewwModule";
    };

    config = lib.mkIf config.ewwModule.enable {
        home.packages = with pkgs; [ eww ];

        xdg.configFile."eww".source = ./config;
    };

}
