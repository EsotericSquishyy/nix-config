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
                env.TERM = "xterm-256color"; #"alacritty";
                font = {
                    size = 15;
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
                    #blur = true; # set in compositor settings
                    opacity = 0.8;
                    padding.x = 10;
                    padding.y = 10;
                    decorations = "None";
                };
                colors = with config.colorScheme.palette; {
                    draw_bold_text_with_bright_colors = true;
                    primary = {
                        foreground = "0x${base07}";
                        background = "0x${base00}";
                    };
                    bright = {
                        black   = "0x${base00}";
                        blue    = "0x${base0D}";
                        cyan    = "0x${base0C}";
                        green   = "0x${base0B}";
                        magenta = "0x${base0E}";
                        red     = "0x${base08}";
                        white   = "0x${base06}";
                        yellow  = "0x${base09}";
                    };
                    normal = {
                        black   = "0x${base00}";
                        blue    = "0x${base0D}";
                        cyan    = "0x${base0C}";
                        green   = "0x${base0B}";
                        magenta = "0x${base0E}";
                        red     = "0x${base08}";
                        white   = "0x${base06}";
                        yellow  = "0x${base0A}";
                    };
                    cursor = {
                        cursor  = "0x${base06}";
                        text    = "0x${base06}";
                    };
                };
            };
        };
    };

}
