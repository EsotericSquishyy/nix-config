# Waybar - Wayland bar
{ pkgs, lib, ...} : {

    home.file.".config/waybar" = {
        source = ../../dotfiles/waybar;
        recursive = true;
    };

}
