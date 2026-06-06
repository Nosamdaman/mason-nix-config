# This file contains my configuration for a Sway-based linux desktop
{ pkgs, ... }: {
    # We'll base this off our base configuration
    imports = [ ./base.nix ];

    # Configure greetd as our display manager
    services.greetd = {
        enable = true;
        useTextGreeter = true;
        settings.default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --remember-session";
        };
    };

    # Configure all programs with complex configuration options
    programs = {
        # Sway is our wayland compositor (obviously)
        #
        # Note that we'll add support for unsupported GPUs by default and XWayland
        sway = {
            enable = true;
            xwayland.enable = true;
            extraOptions = [ "--unsupported-gpu" ];
        };

        # Thunar will be our file manager, we'll add a few plugins to round out its feature set
        thunar = {
            enable = true;
            plugins = with pkgs; [ thunar-archive-plugin thunar-volman ];
        };

        # Firefox will be our primary web browser
        firefox.enable = true;
    };

    # Install the remaining packages for our desktop environment
    environment.systemPackages = with pkgs; [
        # Foot will be our terminal emulator
        foot

        # Rofi will be our launcher
        rofi

        # Mako will be our notification daemon and libnotify will be the intermediate handler
        mako
        libnotify

        # Pavucontrol is how we'll manage audio devices
        pavucontrol
    ];

    # Enable a couple of XDG portals to handle application communication and a few other Wayland features
    xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
    };
}
