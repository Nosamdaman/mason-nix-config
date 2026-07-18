# This file defines a NixOS module describing my basic desktop PC setup.
#
# Note that this does not configure the desktop environment. This module is for software I use independently of my DE.
{ pkgs, ... }: {
    # Import our base configuration
    imports = [ ./base.nix ];

    # Firefox will be our primary web browser
    programs.firefox.enable = true;

    # Thunderbird will be our email client
    programs.thunderbird.enable = true;

    # Enable supprt for Steam, the ultimate PC Gaming platform
    programs.steam = {
        enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    # Configure printing support
    services.printing = {
        enable = true;
        cups-pdf.enable = true;
        drivers = with pkgs; [ cups-filters cups-browsed ];
    };
    services.avahi = {
        enable = true;
        nssmdns4 = true;
    };

    # Enable gamescope, a micro-compositor that can help with game compatibility
    programs.gamescope.enable = true;

    # Install any additional system-wide packages
    environment.systemPackages = with pkgs; [
        # MangoHUD is a game performance HUD and FPS limiter
        mangohud

        # GIMP is useful for Photo/Image editing
        gimp-with-plugins

        # LibreOffice is useful for light desktop office work
        libreoffice-fresh

        # qBitTorrent is for getting our all our ... erm ... Linux ISOs ....
        qbittorrent

        # Spotify is a music service
        spotify
    ];
}
