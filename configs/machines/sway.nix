# This file contains my configuration for a Sway-based linux desktop
{ pkgs, ... }: {
    # We'll base this off our base configuration
    imports = [ ./base.nix ];

    # Configure greetd as our display manager
    services.greetd = {
        enable = true;
        useTextGreeter = false;
        settings.default_session = {
            command = let
                swayLaunchScript = pkgs.writeShellScriptBin "swayLaunchScript" ''
                    export GTK_USE_PORTAL=0
                    export GDK_DEBUG=no-portals
                    ${pkgs.sway}/bin/sway --unsupported-gpu --config /etc/greetd/sway.conf >> /dev/null 2>&1
                '';
            in "${swayLaunchScript}/bin/swayLaunchScript";
        };
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

    # Set global environment variables
    environment.sessionVariables = {
        # This variable tells UWSM to not print to stdout unless there are erros, important for our quiet startup
        UWSM_SILENT_START = "1";

        # This variable tells any wlroots-based wayland compositors to use the Vulkan backend
        WLR_RENDERER = "vulkan";
    };

    # Define any global configuration files
    environment.etc = {
        # This file will configure sway when it is run as the compositor hosting our display manager
        greetd-sway = {
            enable = true;
            target = "/greetd/sway.conf";
            text = ''
                exec "${pkgs.swayidle}/bin/swayidle -w -C /etc/greetd/swayidle.conf"
                include /etc/sway/config.d/*
                exec "${pkgs.regreet}/bin/regreet; ${pkgs.sway}/bin/swaymsg exit"
            '';
        };

        # This file will configure swayidle when the display manager is up
        greetd-swayidle = {
            enable = true;
            target = "/greetd/swayidle.conf";
            text = ''
                timeout 300 '${pkgs.sway}/bin/swaymsg "output * power off"' resume '${pkgs.sway}/bin/swaymsg "output * power on"'
            '';
        };

        # This file configures the global input settings for sway. In particular, we want to disable mouse acceleration
        # and enable numlock by default.
        sway-input = {
            enable = true;
            target = "/sway/config.d/input.conf";
            text = ''
                input "*" {
                  accel_profile flat
                  xkb_numlock enabled
                }
            '';
        };
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

        # SwayIdle will be our idle daemon
        swayidle
    ];

    # Enable a couple of XDG portals to handle application communication and a few other Wayland features
    xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
    };
}
