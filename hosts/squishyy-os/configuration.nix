{
    inputs,
    lib,
    config,
    pkgs,
    ...
}: {
    imports = [
        # inputs.hardware.nixosModules.common-cpu-amd
        # inputs.hardware.nixosModules.common-ssd

        # You can also split up your configuration and import pieces of it here:
        # ./users.nix

        # Import your generated (nixos-generate-config) hardware configuration
        ./hardware-configuration.nix
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

        config = {
            allowUnfree = true;
        };
    };

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nix.nixPath = ["/etc/nix/path"];
    environment.etc =
        lib.mapAttrs'
        (name: value: {
            name = "nix/path/${name}";
            value.source = value.flake;
        })
        config.nix.registry;
    environment.systemPackages = with pkgs; [
        vim
        git
        docker
        lf
    ];

    nix.settings = {
        experimental-features = "nix-command flakes";

        # Deduplicate and optimize nix store
        auto-optimise-store = true;
    };

    # Set your time zone.
    time.timeZone = "America/Los_Angeles";
    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };

    # Enable the X11 windowing system.
    services.xserver = {
        enable = true;
        layout = "us";
        xkbVariant = "";
        displayManager.gdm.enable = true;
        displayManager.gdm.wayland = true;
        # displayManager.sddm.enable = true;
        # displayManager.sddm.theme = "${import ../../theme/sddm-theme.nix {inherit pkgs;}}";
    };

    networking.hostName = "squishyy-os";
    # Enable networking
    networking.networkmanager.enable = true;
    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # TODO: This is just an example, be sure to use whatever bootloader you prefer
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;


    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Bluetooth
    hardware.bluetooth = {
        enable = true; # enables support for Bluetooth
        powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio = {
        enable = false;
        extraConfig = "";
        package = pkgs.pulseaudioFull;
    };
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
    };

    users.users = {
        squishyy = {
            # TODO: You can set an initial password for your user.
            # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
            # Be sure to change it (using passwd) after rebooting!
            initialPassword = "password";
            isNormalUser = true;
            openssh.authorizedKeys.keys = [
                # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
            ];
            extraGroups = [ "networkmanager" "wheel" ];
            shell = pkgs.zsh;
        };
    };

    programs.zsh.enable = true; # Requires for correct sourcing
    users.defaultUserShell = pkgs.zsh; # Required to automatically to use zsh as default

    services.openssh = {
        enable = true;
        settings = {
            # Forbid root login through SSH.
            PermitRootLogin = "no";
            # Use keys only. Remove if you want to SSH using password (not recommended)
            PasswordAuthentication = false;
        };
    };

    # For gaming, not needed with steam
    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
    };
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.gamemode.enable = true;

    # Executables (Can also use 'steam-run zsh' to get shell)
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [];


    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    system.stateVersion = "23.11";
}
