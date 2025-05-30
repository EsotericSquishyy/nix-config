# zsh - Shell
{ pkgs, lib, config, ...}: {

    options.zshModule = {
        enable = lib.mkEnableOption "enables zshModule";
    };

    config = lib.mkIf config.zshModule.enable {
        home.packages = with pkgs; [
            thefuck
        ];

        programs.zsh = {
            enable = true;

            enableCompletion = true;
            syntaxHighlighting.enable = true;

            shellAliases = {
            };

            history.size = 10000;
            history.path = "${config.xdg.dataHome}/zsh/history";

            # Long load time
            # zplug = {
            #     enable = true;
            #     plugins = [ 
            #         # { name = "jeffreytse/zsh-vi-mode"; }
            #         # { name = "zsh-users/zsh-autosuggestions"; }
            #         # { name = "nvbn/thefuck"; }
            #     ];
            # };

            oh-my-zsh = {
                enable = true;
                plugins = [
                    "git"
                    "thefuck"
                ];
            };

            initContent = ''
                eval "$(${pkgs.zoxide}/bin/zoxide init --cmd cd zsh)"
            '';
        };
    };

}
