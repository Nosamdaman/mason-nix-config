{ config, lib, pkgs, ... }:

{
    # Configure nix itself. We'll allow for the installation of non-free software and enable support for flakes and the
    # new nix command line
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Import additional configurations
    imports = [ ./hardware-configuration.nix ];

    # Use the latest kernel
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Set the kernel command-line parameters. We'll use a quiet boot and set the kernel mode to our desired resolution.
    boot.kernelParams = [ "video=DP-1:3440x1440@144" ];

    # Configure the boot process. We'll use systemd boot as our boot loader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Add support for NVIDIA graphics cards
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
        open = true;
        modesetting.enable = true;
    };

    # Use network manager for networking and enable bluetooth support
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;

    # We're in eastern time
    time.timeZone = "US/Eastern";

    # Set the default locale and console settings
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };

    # Configure system services
    services = {
        greetd = {
            enable = true;
            settings = {
                default_session = {
                    command = "${pkgs.tuigreet}/bin/tuigreet --time --remember-session";
                };
            };
        };
    };

    # Install and configure all the system-wide sofware
    programs = {
        fish.enable = true;
        git = {
            enable = true;
            lfs.enable = true;
        };
        htop.enable = true;
        sway = {
            enable = true;
            extraOptions = [ "--unsupported-gpu" ];
        };
        thunar = {
            enable = true;
            plugins = with pkgs; [ thunar-archive-plugin thunar-volman ];
        };
        firefox.enable = true;
        gnupg.agent.enable = true;
    };
    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        liberation_ttf
        nerd-fonts.fira-code
    ];
    environment.systemPackages = with pkgs; [
        vim
        kakoune
        kakoune-lsp
        kak-tree-sitter
        gnupg
        pass-wayland
        git-credential-manager
        tig
        curl
        wget
        unzip
        gcc
        cmakeWithGui
        meson
        ninja
        btop-cuda
        nvtopPackages.full
        alacritty
        rofi
        mako
        xdg-user-dirs
    ];
    xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };

    # Create our user account
    users.users.mason = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
    };

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "25.11"; # Did you read the comment?
}

