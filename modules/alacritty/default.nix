# Alacritty - Terminal Emulator
{ pkgs, lib, ...}: {

    programs.alacritty = {
        enable = true;
        # custom settings
        settings = {
            env.TERM = "xterm-256color";
            font = {
                size = 12;
                draw_bold_text_with_bright_colors = true;
            };
            scrolling.multiplier = 5;
            selection.save_to_clipboard = true;
        };
    };

}
