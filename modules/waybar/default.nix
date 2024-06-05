# Waybar - Wayland bar
{ pkgs, lib, config, ...} : {

    options.waybarModule = {
        enable = lib.mkEnableOption "enables waybarModule";
    };

    config = lib.mkIf config.waybarModule.enable {
        programs.waybar = {
            enable = true;
            style = ./style.css;
        };

        xdg.configFile."waybar/config".source = ./config;
    };

}
