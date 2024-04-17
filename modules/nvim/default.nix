# nvim - Text Editor
{ pkgs, lib, config, ...}: {

    options.nvimModule = {
        enable = lib.mkEnableOption "enables nvimModule";
    };

    config = lib.mkIf config.nvimModule.enable {
        programs.nixvim = {
            enable = true;
	    viAlias = true;
	    vimAlias = true;
        };

        #programs.nvim = {};
    };

}
