# Hyprland - Wayland Compositor
{ pkgs, lib, config, ...}: 
let
    wallpaper = ./../../wallpapers/gruv-sushi-streets.jpg;
    startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
        ${pkgs.swww}/bin/swww init &
        sleep 1 &
        ${pkgs.swww}/bin/swww img ${wallpaper} &
        ${pkgs.waybar}/bin/waybar &
    '';
in
{

    options.hyprlandModule = {
        enable = lib.mkEnableOption "enables hyprlandModule";
    };

    config = lib.mkIf config.hyprlandModule.enable {
        wayland.windowManager.hyprland = {
            enable = true;
            xwayland.enable = true;
            settings = {
                exec-once = ''${startupScript}/bin/start'';

                env = [
                    "XCURSOR_SIZE,24"
                    "HYPRCURSOR_SIZE,24"
                    "QT_QPA_PLATFORMTHEME,qt5ct"
                ];

                monitor = ",preferred,auto,1";

                input = {
                    kb_layout       = "us";
                    kb_variant      = "";
                    kb_model        = "";
                    kb_options      = "";
                    kb_rules        = "";

                    follow_mouse    = 1;

                    touchpad.natural_scroll = true;

                    sensitivity     = 0; # -1.0 - 1.0, 0 means no modification.
                };

                general = with config.colorScheme.palette; {
                    # See https://wiki.hyprland.org/Configuring/Variables/ for more

                    gaps_in                 = 5;
                    gaps_out                = 5; #20
                    border_size             = 2;
                    "col.active_border"     = "rgba(${base0A}ee) rgba(${base08}ee) 45deg";
                    "col.inactive_border"   = "rgba(${base03}aa)";

                    layout                  = "dwindle";

                    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
                    allow_tearing           = false;
                };

                decoration = with config.colorScheme.palette; {
                    # See https://wiki.hyprland.org/Configuring/Variables/ for more

                    rounding = 0; #10

                    blur = {
                        enabled     = true;
                        size        = 4;
                        passes      = 4;
                        vibrancy    = 0.1696;
                        new_optimizations = true;
                    };

                    shadow = {
                        enabled         = true;
                        range           = 4;
                        render_power    = 3;
                        color           = "rgba(1a1a1aee)";
                    };
                };

                animations = {
                    enabled = true;

                    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

                    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

                    animation = [
                        "windows, 1, 7, myBezier"
                        "windowsOut, 1, 7, default, popin 80%"
                        "border, 1, 10, default"
                        "borderangle, 1, 8, default"
                        "fade, 1, 7, default"
                        "workspaces, 1, 6, default"
                    ];
                };

                dwindle = {
                    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
                    pseudotile      = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
                    preserve_split  = true; # you probably want this
                };

                # master = {
                #     # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
                #     new_is_master = true;
                # };

                gestures = {
                    # See https://wiki.hyprland.org/Configuring/Variables/ for more
                    workspace_swipe = false;
                };

                misc = {
                    # See https://wiki.hyprland.org/Configuring/Variables/ for more
                    force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
                };

                # Example per-device config
                # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
                device = {
                    #name = epic-mouse-v1
                    #sensitivity = -0.5
                };

                # Variables
                "$mainMod"          = "SUPER";
                "$terminal"         = "alacritty";
                "$browser"          = "firefox";
                "$fileManager"      = "thunar";
                "$menu"             = "pkill rofi || rofi -show drun";
                "$menuactive"       = "rofi -show window";
                "$exitMenu"         = "wlogout --protocol layer-shell";
                "$volToggle"        = "amixer -q sset Master toggle";
                "$volUp"            = "amixer -q sset Master 5%+";
                "$volDown"          = "amixer -q sset Master 5%-";
                "$brightUp"         = "brightnessctl -q s 5%+";
                "$brightDown"       = "brightnessctl -q s 5%-";
                "$restartWaybar"    = "pkill waybar && waybar";

                # Normal binds
                bind = [
                    "$mainMod, Q, exec, $terminal"
                    "$mainMod, C, killactive,"
                    "$mainMod, M, exec, $exitMenu"
                    "$mainMod, E, exec, $fileManager"
                    "$mainMod, V, togglefloating,"
                    "$mainMod, R, exec, $menu"
                    "$mainMod, T, exec, $menuactive"
                    "$mainMod, P, pseudo," # dwindle
                    "$mainMod, O, togglesplit," # dwindle
                    "$mainMod, F, fullscreen"
                    "$mainMod, Y, exec, $restartWaybar"
                    "$mainMod, B, exec, $browser"

                    # Move focus with mainMod + hjkl
                    "$mainMod, H, movefocus, l"
                    "$mainMod, L, movefocus, r"
                    "$mainMod, J, movefocus, d"
                    "$mainMod, K, movefocus, u"

                    # Move window with mainMod + hjkl
                    "$mainMod SHIFT, H, movewindow, l"
                    "$mainMod SHIFT, L, movewindow, r"
                    "$mainMod SHIFT, J, movewindow, d"
                    "$mainMod SHIFT, K, movewindow, u"

                    # Switch workspaces with mainMod + [0-9]
                    "$mainMod, 1, workspace, 1"
                    "$mainMod, 2, workspace, 2"
                    "$mainMod, 3, workspace, 3"
                    "$mainMod, 4, workspace, 4"
                    "$mainMod, 5, workspace, 5"
                    "$mainMod, 6, workspace, 6"
                    "$mainMod, 7, workspace, 7"
                    "$mainMod, 8, workspace, 8"
                    "$mainMod, 9, workspace, 9"
                    "$mainMod, 0, workspace, 10"
                    "$mainMod, COMMA, workspace, -1"
                    "$mainMod, PERIOD, workspace, +1"

                    # Move active window to a workspace with mainMod + SHIFT + [0-9]
                    "$mainMod SHIFT, 1, movetoworkspace, 1"
                    "$mainMod SHIFT, 2, movetoworkspace, 2"
                    "$mainMod SHIFT, 3, movetoworkspace, 3"
                    "$mainMod SHIFT, 4, movetoworkspace, 4"
                    "$mainMod SHIFT, 5, movetoworkspace, 5"
                    "$mainMod SHIFT, 6, movetoworkspace, 6"
                    "$mainMod SHIFT, 7, movetoworkspace, 7"
                    "$mainMod SHIFT, 8, movetoworkspace, 8"
                    "$mainMod SHIFT, 9, movetoworkspace, 9"
                    "$mainMod SHIFT, 0, movetoworkspace, 10"
                    "$mainMod SHIFT, COMMA, movetoworkspace, -1"
                    "$mainMod SHIFT, PERIOD, movetoworkspace, +1"

                    # Example special workspace (scratchpad)
                    "$mainMod, S, togglespecialworkspace, magic"
                    "$mainMod SHIFT, S, movetoworkspace, special:magic"

                    # Scroll through existing workspaces with mainMod + scroll
                    "$mainMod, mouse_down, workspace, e+1"
                    "$mainMod, mouse_up, workspace, e-1"

                    # screenshot 
                    ", print, exec, grim -g \"$(slurp)\" $HOME/Pictures/Screenshot-$(date +'%s_grim.png') | dunstify \"Screenshot of the region taken\" -t 1000"
                    "CTRL, print, exec, grim $HOME/Pictures/Screenshot-$(date +'%s_grim.png') | dunstify \"Screenshot of whole screen taken\" -t 1000"
                ];

                # Mouse binds
                bindm = [
                    # Move/resize windows with mainMod + LMB/RMB and dragging
                    "$mainMod, mouse:272, movewindow"
                    "$mainMod SHIFT, mouse:272, resizewindow"
                    # "bindm = $mainMod, mouse:273, resizewindow"
                ];

                # Repeat binds
                binde = [
                    # Audo control
                    ", XF86AudioRaiseVolume, exec, $volUp"
                    ", XF86AudioLowerVolume, exec, $volDown"
                    ", XF86AudioMute, exec, $volToggle"

                    # Brightness control
                    ", XF86MonBrightnessUp, exec, $brightUp"
                    ", XF86MonBrightnessDown, exec, $brightDown"

                    # Resize
                    "$mainMod ALT, H, resizeactive, -30 0"
                    "$mainMod ALT, L, resizeactive, 30 0"
                    "$mainMod ALT, J, resizeactive, 0 30"
                    "$mainMod ALT, K, resizeactive, 0 -30"
                ];

                # Release binds
                bindr = [];
                # Lock binds
                bindl = [];
                # Nonconsuming binds
                bindn = [];
                # Transparent binds
                bindt = [];
                # Ignore Mods binds
                bindi = [];
            };
        };
    };

}
