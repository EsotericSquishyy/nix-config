# Hyprland - Wayland Compositor
{ pkgs, pkgs-unstable, lib, config, ...}: {
    options.hyprlandModule = {
        enable = lib.mkEnableOption "enables hyprlandModule";
    };

    config = lib.mkIf config.hyprlandModule.enable {
        home.packages = (with pkgs; [
            # Startup
            swww          # Wallpaper daemon
            waybar        # Status bar

            # Bound extras
            alacritty     # Terminal Emulator
            firefox       # Browser
            xfce.thunar   # File viewer
            alsa-utils    # Sound
            brightnessctl # Brightness
            rofi-wayland  # Application Launcher
            wlogout       # Logout
        ]) ++ (with pkgs-unstable; [
            # unstable packages here
        ]);

        home.file.".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/dotfiles/hypr";

        # wayland.windowManager.hyprland = {
        #     enable = true;
        #     xwayland.enable = true;
        #
        #     # package = pkgs.hyprland;
        #     # systemd.variables = ["--all"]; # If hyprland doesn't export system vars
        # };
    };
}
