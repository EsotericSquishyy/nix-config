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
    colorScheme = inputs.nix-colors.colorSchemes.atelier-forest;

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
        # discord             # Messaging
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
        nodejs_24           # node.js
        libgcc              # gcc, linker is only used in env
        ghc                 # Haskell
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
        dig

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
        nerd-fonts.mononoki
        nerd-fonts.symbols-only
        # nerd-fonts.zed-mono

        # (nerdfonts.override { fonts = [
        #     "NerdFontsSymbolsOnly"
        #     "FiraCode"
        #     "Mononoki"
        # ];})
    ]) ++ (with pkgs-unstable; [
        discord
        nh # Nix Helper
        typst # Out-of-editor compiler for typst
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

    home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
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
    };

    # Copy files over
    #home.file.".config" = {
    #    source = ../../dotfiles;
    #    recursive = true;
    #};

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "25.05";
}
