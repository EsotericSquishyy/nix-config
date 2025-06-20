# TMUX - Terminal Multiplexer
{ pkgs, pkgs-unstable, lib, config, ...}: {
    options.tmuxModule = {
        enable = lib.mkEnableOption "enables tmuxModule";
    };

    config = lib.mkIf config.tmuxModule.enable {
        home.packages = (with pkgs; [
            git
            tmux
        ]) ++ (with pkgs-unstable; [
            # unstable packages here
        ]);

        home.file.".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/tmux";
        home.activation.tpm = lib.hm.dag.entryAfter ["writeBoundary"] ''
            mkdir -p "$HOME/.tmux/plugins"
            if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
                ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
            fi
        '';
    };
}
