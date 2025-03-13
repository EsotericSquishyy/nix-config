# nvim - Text Editor
{ pkgs, pkgs-unstable, lib, config, ...}: {
    options.neovimModule = {
        enable = lib.mkEnableOption "enables neovimModule";
    };
    config = lib.mkIf config.neovimModule.enable {

        home.packages = (with pkgs; [
            lazygit
            zathura # PDF viewer

            # Telescope
            fzf
            ripgrep

            # lsp deps
            lua-language-server
            clang # lsp

            # For making dependencies
            gnumake
        ]) ++ (with pkgs-unstable; [
            tinymist
        ]);


        home.file."./.config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/nvim";

        programs.neovim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
            # extraConfig = config.lib.file.mkOutOfStoreSymlink ./../../dotfiles/nvim;
        };
    };
}
