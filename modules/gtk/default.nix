# GTK - Gnome Themes
{ pkgs, lib, config, ...}: {

    options.gtkModule = {
        enable = lib.mkEnableOption "enables gtkModule";
    };

    config = lib.mkIf config.gtkModule.enable {
        gtk = {
            enable = true;
            theme = {
                name = "Catppuccin-Macchiato-Compact-Pink-Dark";
                package = pkgs.catppuccin-gtk.override {
                    accents = [ "pink" ];
                    size = "compact";
                    tweaks = [ "rimless" "black" ];
                    variant = "macchiato";
                };
            };
        };
    };

}
