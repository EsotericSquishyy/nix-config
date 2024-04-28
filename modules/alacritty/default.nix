# Alacritty - Terminal Emulator
{ pkgs, lib, config, ...}: {

    options.alacrittyModule = {
        enable = lib.mkEnableOption "enables alacrittyModule";
    };

    config = lib.mkIf config.alacrittyModule.enable {
        programs.alacritty = {
            enable = true;
            # custom settings
            settings = {
                env.TERM = "xterm-256color";
                font = {
                    size = 15;
                    draw_bold_text_with_bright_colors = true;
                    normal = {
                        family = "Mononoki Nerd Font";
                        style = "Regular";
                    };
                    bold = {
                        family = "Mononoki Nerd Font";
                        style = "Bold";
                    };
                    italic = {
                        family = "Mononoki Nerd Font";
                        style = "Italic";
                    };
                    bold_italic = {
                        family = "Mononoki Nerd Font";
                        style = "Bold Italic";
                    };
                };
                scrolling.multiplier = 5;
                selection.save_to_clipboard = true;
                window = {
                    blur = true;
                    opacity = 0.9;
                    padding.x = 15;
                    padding.y = 15;
                    decorations = "None";
                };
            };
        };
    };

}
