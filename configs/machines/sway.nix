# This file contains my configuration for a Sway-based linux desktop
{ pkgs, ... }: {
    # We'll base this off our base configuration
    imports = [ ./base.nix ];

    # Configure greetd as our display manager
    services.greetd = {
        enable = true;
        useTextGreeter = false;
        settings.default_session = {
            command = "env GTK_USE_PORTAL=0 GDK_DEBUG=no-portals ${pkgs.sway}/bin/sway --unsupported-gpu --config /etc/greetd/sway.conf >> /dev/null 2>&1";
        };
    };
    environment.etc.greetd-sway = {
        enable = true;
        target = "/greetd/sway.conf";
        text = ''
        exec "${pkgs.regreet}/bin/regreet; ${pkgs.sway}/bin/swaymsg exit"
        include /etc/sway/config.d/*
        '';
    };
    programs.regreet = {
        enable = true;
        theme = {
            name = "Breeze-Dark";
            package = pkgs.kdePackages.breeze-gtk;
        };
        iconTheme = {
            name = "breeze-dark";
            package = pkgs.kdePackages.breeze-icons;
        };
        cursorTheme = {
            name = "Bibata-Modern-Classic";
            package = pkgs.bibata-cursors;
        };
    };
    environment.sessionVariables = {
        UWSM_SILENT_START = "1";
    };

    # Enable Pipewire as our audio server
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };

    # Sway is our wayland compositor (obviously)
    #
    # Note that we'll add support for unsupported GPUs by default and XWayland. We'll also configure our input settins
    # such that numlock is on by default and mouse acceleration is disabled.
    programs.sway = {
        enable = true;
        xwayland.enable = true;
        extraOptions = [ "--unsupported-gpu" ];
    };
    environment.etc.sway-input = {
        enable = true;
        target = "/sway/config.d/input.conf";
        text = ''
        input "*" {
          accel_profile flat
          xkb_numlock enabled
        }
        '';
    };

    # Enable UWSM, which will manage our compositor as a collection systemd targets
    programs.uwsm = {
        enable = true;
        waylandCompositors = {
            sway = {
                prettyName = "Sway";
                comment = "Sway compositor managed by UWSM";
                binPath = "/run/current-system/sw/bin/sway";
            };
        };
    };

    # Thunar will be our file manager, we'll add a few plugins to round out its feature set
    programs.thunar = {
        enable = true;
        plugins = with pkgs; [ thunar-archive-plugin thunar-volman ];
    };

    # Firefox will be our primary web browser
    programs.firefox.enable = true;

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

        # SwayBG will manager our wallpaper
        swaybg
    ];

    # Enable a couple of XDG portals to handle application communication and a few other Wayland features
    xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
    };
}
