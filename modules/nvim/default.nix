# nvim - Text Editor
{ pkgs, lib, config, ...}: {

    options.nvimModule = {
        enable = lib.mkEnableOption "enables nvimModule";
    };
    config = lib.mkIf config.nvimModule.enable {

        home.packages = with pkgs; [
            ripgrep # Telescope
            #zathura # LaTeX
            mupdf
            texliveMedium # LaTeX
        ];

        # https://nix-community.github.io/nixvim/
        programs.nixvim = {
            enable = true;
            viAlias = true;
            vimAlias = true;
            colorschemes.onedark.enable = true;
            globals.mapleader = " ";

            options = {
                syntax = "on";
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
                scrolloff = 7; # Minimum line margin from cursor (top/bottom)
                wrap = true; # Wraps text

                errorbells = false; # Turns off annoying bell for error
                swapfile = false; # Turns off swap-files
            };

            plugins = {
                # Language Server
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

                # Buffer Bar
                bufferline = {
                    enable = true;
                    numbers = "none";
                    mode = "tabs"; # Tabs represent tabs, not buffers
                    showBufferCloseIcons = false;
                    showBufferIcons = false;
                    showCloseIcon = false;
                };

                # Status Bar
                lualine = {
                    enable = true;
                    globalstatus = true; # Avoid split problems (Nvim 0.7+)
                };

                # Color Picker
                nvim-colorizer.enable = true;

                # Explorer
                nvim-tree = {
                    enable = true;

                    git.enable = true;
                    modified = {
                        enable = true;
                        showOnDirs = true;
                        showOnOpenDirs = false;
                    };

                    renderer.addTrailing = true; # '/' trailing on dirs

                    autoClose = true;
                    tab.sync = {
                        close = true;
                        open = true;
                    };

                    hijackNetrw = true; # Keeps cursor on first char
                    openOnSetupFile = true; # Open tree automatically
                    updateFocusedFile.enable = true; # Open dirs to file
                };

                # Fuzzy
                telescope = {
                    enable = true;

                    keymaps = {
                        "<leader>o".action = "find_files"; # Files
                        "<leader>p".action = "builtin"; # Current dir
                        "<leader>i".action = "buffers"; # Current file
                        "<leader>h".action = "help_tags"; # Vim man
                    };
                };

                # LaTeX
                vimtex = {
                    enable = true;
                    #viewMethod =  "zathura";
                    viewMethod =  "mupdf";
                };

                # Typst
                typst-vim = {
                    enable = true;
                };

                #hardtime.enable = true; # Learn vim commands
                #noice.enable = true; # ui for notifs and cmd
                #obsidian.enable = true; # Notes
            };

            keymaps = [
                # Change splits with 'CTRL + [hjkl]'
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

                # NvimTree binds
                {
                    action = ":NvimTreeToggle<CR>";
                    key = "<leader>c";
                    options.silent = false;
                }
            ];

            # Automated Commands
            autoCmd = [
                # Return to cursor position
                {
                    event = [ "BufReadPost" ];
                    command = ''if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif'';
                }
            ];

            # Additional Plugins
            extraPlugins = with pkgs.vimPlugins; [
                {
                    # https://github.com/numToStr/Comment.nvim
                    # 'gb' block, 'gc' line
                    plugin = comment-nvim;
                    config = "lua require(\"Comment\").setup()";
                }
            ];

            # Manual Lua Config
            extraConfigLua = ''
            '';
        };

        #programs.nvim = {};
    };

}
