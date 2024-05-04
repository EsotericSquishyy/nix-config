# Bundles app configs
{ pkgs, lib, ...}: {
    imports = [
        ./hyprland
        ./waybar
        ./starship
        ./alacritty
        ./neovim
        ./pywal
        ./zsh
    ];

    hyprlandModule.enable   = lib.mkDefault true;
    waybarModule.enable     = lib.mkDefault true;
    starshipModule.enable   = lib.mkDefault true;
    alacrittyModule.enable  = lib.mkDefault true;
    neovimModule.enable     = lib.mkDefault true;
    pywalModule.enable      = lib.mkDefault false;
    zshModule.enable        = lib.mkDefault true;
}
