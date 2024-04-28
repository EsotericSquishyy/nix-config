# Module home-manager for squishyy
{
    inputs,
    lib,
    config,
    pkgs,
    pkgs-unstable,
    ...
}: {
    imports = [
        # If you want to use home-manager modules from other flakes (such as nix-colors):
        # inputs.nix-colors.homeManagerModule

        ../../modules
    ];

    nixpkgs = {
        overlays = [
            # If you want to use overlays exported from other flakes:
            # neovim-nightly-overlay.overlays.default

            # Or define it inline, for example:
            # (final: prev: {
            #   hi = final.hello.overrideAttrs (oldAttrs: {
            #     patches = [ ./change-hello-to-hi.patch ];
            #   });
            # })
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
        discord             # Messaging
        obsidian            # Notes
        dropbox             # Cloud Storage
        whatsapp-for-linux  # Messaging
        gimp                # pdf/img editor

        # Toolchains/Compilers/etc.
        nodejs_21           # node.js
        libgcc              # gcc, linker is only used in env
        ghc                 # Haskell

        neofetch            # System info
        nnn                 # terminal file manager

        # For Hyprland
        alacritty           # Terminal Emulator
        waybar              # Bar Widgets
        dunst               # Notif daemon
        swww                # Wallpaper daemon
        rofi-wayland        # App manager
        xfce.thunar         # File Manager

        # archives
        zip
        xz
        unzip
        p7zip

        # utils
        #ripgrep # recursively searches directories for a regex pattern
        #jq # A lightweight and flexible command-line JSON processor
        #yq-go # yaml processor https://github.com/mikefarah/yq
        eza # A modern replacement for ‘ls’
        fzf # A command-line fuzzy finder
        sage # calculator

        # networking tools
        mtr # A network diagnostic tool
        #iperf3
        #dnsutils  # `dig` + `nslookup`
        #ldns # replacement of `dig`, it provide the command `drill`
        #aria2 # A lightweight multi-protocol & multi-source command-line download utility
        bluez # Bluetooth
        networkmanagerapplet

        socat # replacement of openbsd-netcat
        nmap # A utility for network discovery and security auditing
        ipcalc  # it is a calculator for the IPv4/v6 addresses

        # misc
        #cowsay
        file
        which
        tree
        #gnused
        #gnutar
        #gawk
        #zstd
        #gnupg

        # productivity
        #hugo # static site generator
        glow # markdown previewer in terminal

        # system monitors
        #btop  # replacement of htop/nmon
        #iotop # io monitoring
        #iftop # network monitoring
        bottom # 'btm'
        brightnessctl

        # system call monitoring
        #strace # system call monitoring
        #ltrace # library call monitoring
        #lsof # list open files

        # system tools
        wlogout # Logout menu
        #sysstat
        #lm_sensors # for `sensors` command
        #ethtool
        #pciutils # lspci
        #usbutils # lsusb

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

    # Copy files over
    #home.file.".config" = {
    #    source = ../../dotfiles;
    #    recursive = true;
    #};

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "23.11";
}
