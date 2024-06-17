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
in {

    options.neovimModule = {
        enable = lib.mkEnableOption "enables neovimModule";
    };
    config = lib.mkIf config.neovimModule.enable {

        home.packages = with pkgs; [
            ripgrep # Telescope
            zathura # LaTeX
            texliveFull # LaTeX
        ];

        # https://nix-community.github.io/nixvim/
        programs.nixvim = {
            enable = true;
            viAlias = true;
            vimAlias = true;
            defaultEditor = true;
            #colorschemes.onedark.enable = true;
            colorschemes.base16 = {
                enable = true;
                customColorScheme = with config.colorScheme.palette; {
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
            globals.mapleader = " ";

            options = {
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
                        clangd.enable = true;
                        rust-analyzer.enable = true;
                        html.enable = true;
                        typst-lsp.enable = true;
                    };
                };

                #luasnip.enable = true;

                # Autocomplete
                cmp = {
                    enable = true;
                    settings.mapping = {
                        "<C-Space>" = "cmp.mapping.complete()";
                        "<C-d>"     = "cmp.mapping.scroll_docs(-4)";
                        "<C-e>"     = "cmp.mapping.close()";
                        "<C-f>"     = "cmp.mapping.scroll_docs(4)";
                        "<CR>"      = "cmp.mapping.confirm({ select = true })";
                        "<S-Tab>"   = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
                        "<Tab>"     = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
                    };
                    autoEnableSources = true;
                    settings.sources = [
                        { name = "nvim_lsp"; }
                        #{ name = "luasnip"; }
                        { name = "buffer"; }
                        { name = "path"; }
                    ];

                };

                # Buffer Bar
                bufferline = {
                    enable = true;
                    numbers = "none";
                    mode = "tabs"; # Tabs represent tabs, not buffers
                    showBufferCloseIcons = false;
                    showBufferIcons = false;
                    showCloseIcon = false;
                    highlights = {
                        fill.bg             = "none"; # Bar bg
                        background.bg       = "none"; # Unselected tab bg
                        bufferSelected.bg   = "none"; # Selected tab bg
                        separator.bg        = "none"; # Separator bg
                    };
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
                        "<leader>i".action = "live_grep"; # Current dir
                        "<leader>h".action = "help_tags"; # Vim man
                    };
                };

                # LaTeX
                vimtex = {
                    enable = true;
                    viewMethod =  "zathura";
                };

                # Typst
                typst-vim = {
                    enable = true;
                    pdfViewer = "zathura";
                    keymaps.watch = "<leader>l";
                    keymaps.silent = true;
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
                vim.cmd([[
                    hi Normal ctermbg=none guibg=none
                    hi NormalNC ctermbg=none guibg=none
                    hi NonText ctermbg=none guibg=none
                    hi LineNr ctermbg=none guibg=none
                ]])
            '';
        };

        #programs.nvim = {};
    };

}
