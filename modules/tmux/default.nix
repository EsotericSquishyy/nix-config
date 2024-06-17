# TMUX - Terminal Multiplexer
{ pkgs, lib, config, ...}: {

    options.tmuxModule = {
        enable = lib.mkEnableOption "enables tmuxModule";
    };

    config = lib.mkIf config.tmuxModule.enable {
        programs.tmux = {
            enable = true;
            sensibleOnTop = false; # Disable sensible plugin
            # customPaneNavigationAndResize = true;
            clock24 = true;
            disableConfirmationPrompt = true;
            prefix = "C-s";
            escapeTime = 0;
            # keyMode = "vi"; # Apparently 'emacs' binds are better for TMUX
            mouse = true;
            baseIndex = 1;

            plugins = with pkgs.tmuxPlugins; [

            ];

            extraConfig = ''
                set -g focus-events on

                bind -n M-h select-pane -L
                bind -n M-j select-pane -D
                bind -n M-k select-pane -U
                bind -n M-l select-pane -R

                bind -n M-H previous-window
                bind -n M-L next-window

                # split current window horizontally
                bind - split-window -v
                # split current window vertically
                bind _ split-window -h

                bind > swap-pane -D       # swap current pane with the next one
                bind < swap-pane -U       # swap current pane with the previous one

                setw -g automatic-rename on   # rename window to reflect current program
                set -g renumber-windows on    # renumber windows when a window is closed
                set -g set-titles on          # set terminal title

                bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

            '';
                # bind r source-file ${config.xdg.configHome}/tmux/tmux.config
        };
    };
}
