# Bundles app configs
{ pkgs, lib, ...}: {
    imports = [
        ./hyprland
        ./waybar
        ./starship
        ./alacritty
        ./neovim
        ./zsh
        ./ags
    ];

    hyprlandModule.enable   = lib.mkDefault true;
    waybarModule.enable     = lib.mkDefault true;
    starshipModule.enable   = lib.mkDefault true;
    alacrittyModule.enable  = lib.mkDefault true;
    neovimModule.enable     = lib.mkDefault true;
    zshModule.enable        = lib.mkDefault true;
    agsModule.enable        = lib.mkDefault true;
}
