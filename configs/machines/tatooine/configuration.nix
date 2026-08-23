# This is the configuration for my primary Linux gaming/programming desktop, coruscant
{ config, pkgs, ... }: {
    # Import our base configurations. This desktop is based off of my Sway template and an auto-generated hardware
    # configuration.
    imports = [ ../niri.nix ./hardware-configuration.nix ];

    # Enable hardware acceleration
    hardware.graphics = {
        enable = true;
        extraPackages = [ pkgs.intel-media-driver ];
    };

    # Set the hostname
    networking.hostName = "tatooine";

    # Use the Systemd-Boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Set our vanity boot options
    boot.plymouth.enable = true;
    boot.kernelParams = [ "quiet" ];

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
