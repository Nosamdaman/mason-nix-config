# This is the configuration for my primary Linux gaming/programming desktop, coruscant
{ config, pkgs, ... }: {
    # Import our base configurations. This desktop is based off of my Sway template and an auto-generated hardware
    # configuration.
    imports = [ ../niri.nix ./hardware-configuration.nix ];

    # Set the hostname
    networking.hostName = "coruscant-niri";

    # Add support for NVIDIA graphics cards
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
        open = true;
        modesetting.enable = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
    };

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Set our vanity boot options. We'll enable Plymouth for a nice boot splash screen. Note that by loading the NVIDIA
    # modules early, we make Plymouth work much more consistently. We'll also silence the boot messages prior to
    # Plymouth starting and set our resoltion to the correct mode.
    boot.plymouth.enable = true;
    boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    boot.kernelParams = [ "quiet" "video=DP-1:3440x1440@144" ];

    # Disable sleep, this is a desktop, we don't want it
    systemd.sleep.settings.Sleep = {
        AllowSuspend = "no";
        AllowHibernation = "no";
        AllowHybridSleep = "no";
        AllowSuspendThenHibernate = "no";
    };

    # Set the video mode for sway globally using a custom config
    environment.etc.sway-output = {
        enable = true;
        target = "/sway/config.d/output.conf";
        text = ''
        output DP-1 mode 3440x1440@144Hz
        '';
    };

    # Configure font anti-aliasing settings for our monitor
    fonts = {
        fontconfig = {
            enable = true;
            antialias = true;
            hinting = {
                enable = true;
                style = "slight";
            };
            subpixel = {
                lcdfilter = "none";
                rgba = "none";
            };
        };
    };

    # Enable support for bluetooth
    hardware.bluetooth.enable = true;

    # Install any additional system-wide packages
    environment.systemPackages = with pkgs; [
        # BlueTUI provides a nice TUI from which we can manage our bluetooth connections
        bluetui
    ];

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
