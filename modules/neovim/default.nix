# nvim - Text Editor
{ pkgs, lib, config, ...}: 

# https://github.com/NixOS/nixpkgs/blob/nixos-23.11/pkgs/applications/editors/vim/plugins/vim-plugin-names
# https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/vim.section.md
let
    transparent-nvim = pkgs.vimUtils.buildVimPlugin {
        name = "transparent.nvim";
        src = pkgs.fetchFromGitHub {
            owner = "xiyaowong";
            repo = "transparent.nvim";
            rev = "main";
            hash = "sha256-wT+7rmp08r0XYGp+MhjJX8dsFTar8+nf10CV9OdkOSk=";
        };
    };
    helpers = config.lib.nixvim;
in {
    options.neovimModule = {
        enable = lib.mkEnableOption "enables neovimModule";
    };
    config = lib.mkIf config.neovimModule.enable {

        home.packages = with pkgs; [
            ripgrep # Telescope
            lazygit
            zathura # LaTeX
            texliveFull # LaTeX
        ];

        # https://nix-community.github.io/nixvim/
        programs.nixvim = {
            enable = true;
            viAlias = true;
            vimAlias = true;
            defaultEditor = true;
            # colorschemes.onedark.enable = true;
            colorschemes.base16 = {
                enable = true;
                colorscheme = with config.colorScheme.palette; {
                    base00 = "#${base00}";
                    base01 = "#${base01}";
                    base02 = "#${base02}";
                    base03 = "#${base03}";
                    base04 = "#${base04}";
                    base05 = "#${base05}";
                    base06 = "#${base06}";
                    base07 = "#${base07}";
                    base08 = "#${base08}";
                    base09 = "#${base09}";
                    base0A = "#${base0A}";
                    base0B = "#${base0B}";
                    base0C = "#${base0C}";
                    base0D = "#${base0D}";
                    base0E = "#${base0E}";
                    base0F = "#${base0F}";
                };
            };
            globals = {
                mapleader = " ";
                maplocalleader = "\\";
            };

            opts = {
                termguicolors = true;
                syntax = "on";
                number = true; # Show line numbers
                relativenumber = true;

                expandtab = true; # spaces for tabs, 'retab'
                shiftwidth = 4; # Indentation of '>>' or '<<'
                tabstop = 4; # Indentation of '\t'
                softtabstop = 0; # Indentation of [tab] or [backspace]
                autoindent = true;

                list = true;
                listchars = ''trail:~,tab:>-,nbsp:␣''; # chars for invisible chars (removed: eol = "↵")

                # wildmenu = true;
                # wildmode = "list:longest";
                # wildignore = "*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx";

                signcolumn = "number"; # Prevent shifting from lsp warnings
                scrolloff = 7; # Minimum line margin from cursor (top/bottom)
                wrap = true; # Wraps text

                errorbells = false; # Turns off annoying bell for error
                swapfile = false; # Turns off swap-files
            };

            plugins = {
                # Dependency
                web-devicons.enable = true;
                # mini = {
                #     enable = true;
                #     modules.icons = true;
                #     mockDevIcons = true;
                # };

                # Language Server
                lsp = {
                    enable = true;

                    servers = {
                        gdscript = {
                            enable = true;
                            package = null;
                        };
                        ts_ls.enable = true;

                        lua_ls = {
                          enable = true;
                          settings.telemetry.enable = false;
                        };
                        pyright.enable = true;
                        nil_ls.enable = true;
                        clangd.enable = true;
                        rust_analyzer = {
                            enable = true;
                            installCargo = true;
                            installRustc = true;
                        };
                        html.enable = true;
                        typst_lsp.enable = true;
                        # leanls.enable = true; # Error with rust version
                    };
                };

                treesitter = {
                    enable = true;

                    settings.indent.enable = true;
                };

                tmux-navigator.enable = true;

                transparent = {
                    enable = true;
                    settings.enable = true;
                };

                # friendly-snippets.enable = true;
                luasnip = {
                    enable = true;
                    fromLua = [
                        {}
                        {
                            paths = ./snippets;
                            include = [ "nix" ];
                        }
                    ];
                    fromSnipmate = [ {} ];
                    fromVscode = [ {} ];
                };

                # Blink - https://cmp.saghen.dev/
                blink-cmp = {
                    enable = true;
                    settings = {
                        keymap.preset = "super-tab";
                        windows.documentation.auto_show = true;
                        snippets = {
                            expand = helpers.mkRaw ''
                                function(snippet)
                                    require('luasnip').lsp_expand(snippet)
                                end
                            '';
                            active = helpers.mkRaw ''
                                function(filter)
                                    if filter and filter.direction then
                                        return require('luasnip').jumpable(filter.direction)
                                    end
                                    return require('luasnip').in_snippet()
                                end
                            '';
                            jump = helpers.mkRaw ''
                                function(direction)
                                    require('luasnip').jump(direction)
                                end
                            '';
                        };
                        sources = {
                            default = [
                                "lps"
                                "path"
                                "snippets"
                                "luasnip"
                                "buffer"
                            ];
                        };
                    };
                };

                # Alpha (Greeter)
                alpha = {
                    enable = true;
                    theme = "theta";
                };

                # nvim-cmp
                # cmp = {
                #     enable = true;
                #     settings.mapping = {
                #         "<C-Space>" = "cmp.mapping.complete()";
                #         "<C-d>"     = "cmp.mapping.scroll_docs(-4)";
                #         "<C-e>"     = "cmp.mapping.close()";
                #         "<C-f>"     = "cmp.mapping.scroll_docs(4)";
                #         "<CR>"      = "cmp.mapping.confirm({ select = true })";
                #         "<S-Tab>"   = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
                #         "<Tab>"     = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
                #     };
                #     autoEnableSources = true;
                #     settings.sources = [
                #         { name = "nvim_lsp"; }
                #         #{ name = "luasnip"; }
                #         { name = "buffer"; }
                #         { name = "path"; }
                #     ];
                # };

                # Buffer Bar
                bufferline = {
                    enable = true;
                    settings = {
                        options = {
                            numbers = "none";
                            mode = "tabs"; # Tabs represent tabs, not buffers
                            show_buffer_close_icons = false;
                            show_buffer_icons = false;
                            show_close_icon = false;
                        };
                        highlights = {
                            fill.bg             = "none"; # Bar bg
                            background.bg       = "none"; # Unselected tab bg
                            buffer_selected.bg  = "none"; # Selected tab bg
                            separator.bg        = "none"; # Separator bg
                        };
                    };
                };

                # Status Bar
                lualine = {
                    enable = true;
                    settings.options.globalstatus = true; # Avoid split problems (Nvim 0.7+)
                };

                # Color Picker
                nvim-colorizer.enable = true;

                # Lazygit
                lazygit.enable = true;

                # Explorer
                # nvim-tree = {
                #     enable = true;
                #
                #     git.enable = true;
                #     modified = {
                #         enable = true;
                #         showOnDirs = true;
                #         showOnOpenDirs = false;
                #     };
                #
                #     renderer.addTrailing = true; # '/' trailing on dirs
                #
                #     autoClose = true;
                #     tab.sync = {
                #         close = true;
                #         open = true;
                #     };
                #
                #     hijackNetrw = true; # Keeps cursor on first char
                #     openOnSetupFile = true; # Open tree automatically
                #     updateFocusedFile.enable = true; # Open dirs to file
                # };

                # Oil
                oil.enable = true;

                # Fuzzy
                telescope = {
                    enable = true;

                    keymaps = {
                        "<leader>ff".action = "find_files";
                        "<leader>fb".action = "builtin";
                        "<leader>fg".action = "live_grep";
                        "<leader>fh".action = "help_tags";
                    };
                };

                # LaTeX
                vimtex = {
                    enable = true;
                    settings.view_method =  "zathura";
                    settings = {
                        quickfix_ignore_filters = [
                            "Underfull"
                            "Overfull"
                            "specifier changed to"
                            "Token not allowed in a PDF string"
                        ];
                        # https://github.com/lervag/vimtex/issues/2046
                        # extraConfig = ''
                        #     function vimtex.viewer.xdo_find_win_id_by_pid(pid)
                        #         return 1
                        #     end
                        # '';
                    };
                };

                # Typst
                typst-vim = {
                    enable = true;
                    settings.pdf_viewer = "zathura";
                    keymaps.watch = "<leader>w";
                    keymaps.silent = true;
                };

                # Lean - Theorem Prover
                lean = {
                    enable = true;
                    mappings = true;
                };

                #hardtime.enable = true; # Learn vim commands
                #noice.enable = true; # ui for notifs and cmd
                #obsidian.enable = true; # Notes
            };

            keymaps = [
                # Lazygit binds
                {
                    action = ":LazyGit<CR>";
                    mode = "n";
                    key = "<leader>l";
                    options.silent = true;
                }

                # Oil binds
                {
                    action = ":Oil<CR>";
                    mode = "n";
                    key = "-";
                    options.silent = true;
                }

                # Term commands
                {
                    action = "<c-\\><c-n>";
                    mode = "t";
                    key = "<esc><esc>";
                }

                # NvimTree binds
                # {
                #     action = ":NvimTreeToggle<CR>";
                #     mode = "n";
                #     key = "<leader>c";
                #     options.silent = false;
                # }
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
            # extraConfigLua = ''
            # '';
        };
        #programs.nvim = {};
    };
}
