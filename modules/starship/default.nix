# Starship - Customizable prompt for shell
{ pkgs, lib, ...}: {

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

}
