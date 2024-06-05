# TMUX - Terminal Multiplexer
{ pkgs, lib, config, ...}: {

    options.tmuxModule = {
        enable = lib.mkEnableOption "enables tmuxModule";
    };

    config = lib.mkIf config.tmuxModule.enable {
        programs.tmux = {
            enable = true;
            customPaneNavigationAndResize = true;
        };
    };

}
