# AGS - Widgets
{ pkgs, lib, config, ...}: {

    options.agsModule = {
        enable = lib.mkEnableOption "enables agsModule";
    };

    config = lib.mkIf config.agsModule.enable {
        programs.ags = {
            enable = true;

            configDir = ./config;

            extraPackages = with pkgs; [];
        };
    };

}
