# nvim - Text Editor
{ pkgs, lib, config, ...}: {

    options.nvimModule = {
        enable = lib.mkEnableOption "enables nvimModule";
    };
    config = lib.mkIf config.nvimModule.enable {

        # https://nix-community.github.io/nixvim/
        programs.nixvim = {
            enable = true;
            viAlias = true;
            vimAlias = true;
            colorschemes.onedark.enable = true;
            globals.mapleader = " ";

            options = {
                number = true; # Show line numbers

                expandtab = true; # spaces for tabs, 'retab'
                shiftwidth = 4; # Indentation of '>>' or '<<'
                tabstop = 4; # Indentation of '\t'
                softtabstop = 0; # Indentation of [tab] or [backspace]
                autoindent = true;

                list = true;
                listchars = ''eol:↵,trail:~,tab:>-,nbsp:␣''; # chars for invisible chars

                wildmenu = true;
                wildmode = "list:longest";
                # wildignore = "*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx";

                signcolumn = "number"; # Prevent shifting from lsp warnings
            };

            plugins = {
                lsp = {
                    enable = true;

                    servers = {
                        tsserver.enable = true;

                        lua-ls = {
                          enable = true;
                          settings.telemetry.enable = false;
                        };
                        pyright.enable = true;
                        nil_ls.enable = true;
                    };
                };
            };

            keymaps = [
                {
                    action = ":wincmd h<CR>";
                    key = "<C-h>";
                    options.silent = true;
                }
                {
                    action = ":wincmd j<CR>";
                    key = "<C-j>";
                    options.silent = true;
                }
                {
                    action = ":wincmd k<CR>";
                    key = "<C-k>";
                    options.silent = true;
                }
                {
                    action = ":wincmd l<CR>";
                    key = "<C-l>";
                    options.silent = true;
                }
            ];

            # extraPlugins = with pkgs.vimPlugins; [];

            extraConfigLua = ''
            '';
        };

        #programs.nvim = {};
    };

}
