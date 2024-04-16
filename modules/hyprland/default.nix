# Hyprland - Wayland Compositor
{ pkgs, lib, config, ...}: 
let
    wallpaper = ./../../wallpapers/houses-dark.png;
    startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
        ${pkgs.swww}/bin/swww init &
        sleep 1 &
        ${pkgs.swww}/bin/swww img ${wallpaper} &
        ${pkgs.waybar}/bin/waybar &
    '';
in
{

    options.hyprlandModule = {
        enable = lib.mkEnableOption "enables hyprlandModule";
    };

    config = lib.mkIf config.hyprlandModule.enable {
        wayland.windowManager.hyprland = {
            enable = true;
            xwayland.enable = true;
            settings = {
                exec-once = ''${startupScript}/bin/start'';
            };
            extraConfig = builtins.readFile ./hyprland.conf;
        };
    };

}
