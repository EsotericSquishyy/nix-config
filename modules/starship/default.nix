# Starship - Customizable prompt for shell
{ pkgs, lib, config, ...}: {

    options.starshipModule = {
        enable = lib.mkEnableOption "enables starshipModule";
    };

    config = lib.mkIf config.starshipModule.enable {
        programs.starship = {
            enable = true;
            # custom settings
            settings = {
                add_newline = false;
                aws.disabled = true;
                gcloud.disabled = true;
                line_break.disabled = true;
            };
        };
    };

}
