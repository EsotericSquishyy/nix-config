# Hyprland - Wayland Compositor
{ pkgs, lib, config, ...}: 
let
    startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
        ${pkgs.swww}/bin/swww init &
        sleep 1 &
        ${pkgs.swww}/bin/swww img ${./../../wallpapers/forest_3840_2160.jpeg} &

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
