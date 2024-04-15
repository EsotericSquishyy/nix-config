# Bundles app configs
{ pkgs, lib, ...}: {
    imports = [
        ./hyprland
        ./waybar
        ./starship
        ./alacritty
    ];

    hyprlandModule.enable   = lib.mkDefault true;
    waybarModule.enable     = lib.mkDefault true;
    starshipModule.enable   = lib.mkDefault true;
    alacrittyModule.enable  = lib.mkDefault true;
}
