# Pywal - color generator
{ pkgs, lib, config, ...}: {

    options.pywalModule = {
        enable = lib.mkEnableOption "enables pywalModule";
    };

    config = lib.mkIf config.pywalModule.enable {
        programs.pywal = {
            enable = true;
        };
    };

}
