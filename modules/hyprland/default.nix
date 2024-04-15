# Hyprland - Wayland Compositor
{ pkgs, lib, ...}: 
let
    startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
        ${pkgs.swww}/bin/swww init &
        sleep 1 &
        ${pkgs.swww}/bin/swww img ${./../../wallpapers/forest_3840_2160.jpeg} &

    '';
in
{

    wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        settings = {
            exec-once = ''${startupScript}/bin/start'';
        };
        extraConfig = builtins.readFile ./../../dotfiles/hypr/hyprland.conf;
    };

}
