# Module home-manager for squishyy
{
    inputs,
    lib,
    config,
    pkgs,
    pkgs-unstable,
    ...
}: let
inherit (inputs.nix-colors.lib-contrib {inherit pkgs;}) gtkThemeFromScheme;
gruvboxplus = import ./icons/gruvbox-plus.nix { inherit pkgs; };
in {
    imports = [
        inputs.nix-colors.homeManagerModules.default
        inputs.nixvim.homeManagerModules.nixvim
        inputs.hyprland.homeManagerModules.default
        # inputs.ags.homeManagerModules.default # Eww alternative
        ../../modules
    ];

    nixpkgs = {
        overlays = [
            # If you want to use overlays exported from other flakes:
            # neovim-nightly-overlay.overlays.default
        ];
        # Configure your nixpkgs instance
        config = {
            # Disable if you don't want unfree packages
            allowUnfree = true;
            # Workaround for https://github.com/nix-community/home-manager/issues/2942
            allowUnfreePredicate = _: true;

            # For Obsidian
            permittedInsecurePackages = [
                "electron-25.9.0"
            ];
        };
    };

    # https://tinted-theming.github.io/base16-gallery/
    # colorScheme = inputs.nix-colors.colorSchemes.heetch;
    colorScheme = inputs.nix-colors.colorSchemes.darkmoss;
        # base00: #171e1f
        # base01: #252c2d
        # base02: #373c3d
        # base03: #555e5f
        # base04: #818f80
        # base05: #c7c7a5
        # base06: #e3e3c8
        # base07: #e1eaef
        # base08: #ff4658
        # base09: #e6db74
        # base0A: #fdb11f
        # base0B: #499180
        # base0C: #66d9ef
        # base0D: #498091
        # base0E: #9bc0c8
        # base0F: #d27b53
    # colorScheme = {
    #     slug = "sushi";
    #     name = "Sushi";
    #     author = "pywal - squishyy";
    #     palette = {
    #         base00 = "#0E121B";
    #         base01 = "#4C4D4F";
    #         base02 = "#6C6A5F";
    #         base03 = "#C15E59";
    #         base04 = "#6F8F70";
    #         base05 = "#979274";
    #         base06 = "#DC9548";
    #         base07 = "#c8cbba";
    #         base08 = "#8c8e82";
    #         base09 = "#4C4D4F";
    #         base0A = "#6C6A5F";
    #         base0B = "#C15E59";
    #         base0C = "#6F8F70";
    #         base0D = "#979274";
    #         base0E = "#DC9548";
    #         base0F = "#c8cbba";
    #     };
    # };

    home = {
        username = "squishyy";
        homeDirectory = "/home/squishyy";
    };

    fonts.fontconfig.enable = true;

    #programs.nh.enable = true;
    programs.zsh.enable = true;

    home.packages = (with pkgs; [
        # Applications
        firefox             # Browser
        ungoogled-chromium  # Browser
        discord             # Messaging
        # xwaylandvideobridge # Fix for discord screen-sharing
        obsidian            # Notes
        whatsapp-for-linux  # Messaging
        inkscape
        unityhub
        obs-studio          # Screen Recorder
        jellyfin-ffmpeg     # File converter and Video Player
        # libsForQt5.kdenlive # Video Editor
        godot_4
        lazygit
        openvpn
        usbimager

        # Gaming
        mangohud            # FPS and System status
        # lutris              # Game Launcher
        protonup-qt         # Proton-GE manager
        # protontricks        # wintricks commands for proton

        # Toolchains/Compilers/etc.
        nodejs_22           # node.js
        libgcc              # gcc, linker is only used in env
        ghc                 # Haskell
        typst               # Out-of-editor compiler for typst
        lean4               # Lean4 - Theorem Prover

        neofetch            # System info
        nnn                 # terminal file manager
        pywal               # Generate color palettes

        # For Hyprland/General
        alacritty           # Terminal Emulator
        waybar              # Bar Widgets
        dunst               # Notif daemon
        swww                # Wallpaper daemon
        rofi-wayland        # App manager
        xfce.thunar         # File Manager
        wl-clipboard        # Clipboard tool for nvim
        slurp               # Region Selector
        grim                # Image Grabber
        vlc                 # Media Player
        # mpv                 # Media Player
        qview               # Image viewer


        # archives
        zip
        xz
        unzip
        p7zip

        # utils
        ripgrep # recursively searches directories for a regex pattern
        eza # A modern replacement for ‘ls’
        fzf # A command-line fuzzy finder
        zoxide
        sage # calculator
        imagemagick # Image compressor/converter
        radare2

        # networking tools
        mtr # A network diagnostic tool
        bluez # Bluetooth
        # networkmanagerapplet

        socat # replacement of openbsd-netcat
        nmap # A utility for network discovery and security auditing
        ipcalc  # it is a calculator for the IPv4/v6 addresses

        # misc
        file
        which
        tree
        bat
        wget

        # productivity
        glow # markdown previewer in terminal

        # system monitors
        #btop  # replacement of htop/nmon
        #iotop # io monitoring
        #iftop # network monitoring
        bottom # 'btm'
        brightnessctl
        pulseaudio

        # system call monitoring
        #strace # system call monitoring
        ltrace # library call monitoring
        #lsof # list open files

        # system tools
        wlogout # Logout menu
        #sysstat

        # Fonts
        font-awesome
        powerline-fonts
        powerline-symbols
        (nerdfonts.override { fonts = [
            "NerdFontsSymbolsOnly"
            "FiraCode"
            "Mononoki"
        ];})
    ]) ++ (with pkgs-unstable; [
        nh # Nix Helper
    ]);

    # Enable home-manager and git
    programs.home-manager.enable = true;
    programs.git = {
        enable = true;
        userName = "EsotericSquishyy";
        userEmail = "jesselcobb@gmail.com";
    };

    programs.bash = {
        enable = true;
        enableCompletion = true;
        bashrcExtra = ''
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
        '';

        shellAliases = {
        };
    };

    gtk = {
        enable = true;
        theme = {
            name = "${config.colorScheme.slug}";
            package = gtkThemeFromScheme { scheme = config.colorScheme; };
        };
        iconTheme = {
            package = pkgs.zafiro-icons;
            name = "Zafiro-icons-Dark";
        };
        cursorTheme = {
            /* package = pkgs.graphite-cursors;
            name = "graphite-dark"; */
            package = pkgs.bibata-cursors;
            name = "Bibate-Modern-Ice";
            size = 17;
        };
    };

    # Copy files over
    #home.file.".config" = {
    #    source = ../../dotfiles;
    #    recursive = true;
    #};

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "24.11";
}
