# TMUX - Terminal Multiplexer
{ pkgs, lib, config, ...}: 
let
    powerline = pkgs.tmuxPlugins.mkTmuxPlugin {
        pluginName = "powerline";
        version = "06-27-24";
        src = pkgs.fetchFromGitHub {
            owner = "erikw";
            repo = "tmux-powerline";
            rev = "6aea97f0da6fcbf961ade75ccf2d63083f818540";
            sha256 = "sha256-mmmmnlPzzs5oDxLWPthWrYqiy8s2Kn9L2A48Bc8lZxw=";
        };
    };

in {

    options.tmuxModule = {
        enable = lib.mkEnableOption "enables tmuxModule";
    };

    config = lib.mkIf config.tmuxModule.enable {
        programs.tmux = {
            enable          = true;
            sensibleOnTop   = false; # Disable sensible plugin
            clock24         = true;
            prefix          = "C-s";
            escapeTime      = 0;
            keyMode         = "vi";
            mouse           = true;
            baseIndex       = 1;
            disableConfirmationPrompt = true;

            plugins = with pkgs.tmuxPlugins; [
                powerline
                vim-tmux-navigator
                resurrect
                continuum
            ];

            extraConfig = ''
                set -g focus-events on

                # Resizing
                bind -r h resize-pane -L 5
                bind -r j resize-pane -D 5
                bind -r k resize-pane -K 5
                bind -r l resize-pane -R 5

                # https://github.com/christoomey/vim-tmux-navigator/issues/317#issuecomment-2483129754
                bind -n C-h run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-h) || tmux select-pane -L"
                bind -n C-j run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-j) || tmux select-pane -D"
                bind -n C-k run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-k) || tmux select-pane -U"
                bind -n C-l run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-l) || tmux select-pane -R"
                bind -n C-\\ run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys 'C-\\') || tmux select-pane -l"

                # Splitting
                bind - split-window -v
                bind _ split-window -h

                bind > swap-pane -D             # swap current pane with the next one
                bind < swap-pane -U             # swap current pane with the previous one

                setw -g automatic-rename on     # rename window to reflect current program
                set -g renumber-windows on      # renumber windows when a window is closed
                set -g set-titles on            # set terminal title

                # Reloading
                bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

            '';
                # bind r source-file ${config.xdg.configHome}/tmux/tmux.config
        };
    };
}
