# zsh - Shell
{ pkgs, lib, config, ...}: {

    options.zshModule = {
        enable = lib.mkEnableOption "enables zshModule";
    };

    config = lib.mkIf config.zshModule.enable {
        programs.zsh = {
            enable = true;

            enableCompletion = true;
            syntaxHighlighting.enable = true;

            shellAliases = {
            };

            history.size = 10000;
            history.path = "${config.xdg.dataHome}/zsh/history";

            zplug = {
                enable = true;
                plugins = [ 
                    # { name = "jeffreytse/zsh-vi-mode"; }
                    { name = "zsh-users/zsh-autosuggestions"; }
                ];
            };

            initExtra = ''
                eval "$(${pkgs.zoxide}/bin/zoxide init --cmd cd zsh)"
            '';
        };
    };

}
