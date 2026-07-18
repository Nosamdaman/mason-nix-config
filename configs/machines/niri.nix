# Configure a niri-based desktop environment
{ config, pkgs, ... }: {
    # We'll base this off our desktop configuration
    imports = [ ./desktop.nix ];

    # Niri will be our window-manager/compositor (obviously)
    programs.niri = {
        enable = true;
        useNautilus = false;
    };

    # Configure Polkit for GUI authentication
    security.polkit.enable = true;
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
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

    # Thunar will be our file manager, we'll add a few plugins to round out its feature set
    programs.thunar = {
        enable = true;
        plugins = with pkgs; [ thunar-archive-plugin thunar-volman ];
    };

    # Enable GVfs, a service that will automatically mount stuff for us and iteracti with Thunar
    services.gvfs.enable = true;

    # Install the remaining packages for our desktop environment
    environment.systemPackages = with pkgs; [
        # Foot will be our terminal emulator
        foot

        # Rofi will be our launcher
        rofi

        # Cliphist and wl-clipboard will manage our clipboard history
        cliphist
        wl-clipboard

        # Mako will be our notification daemon and libnotify will be the intermediate handler
        mako
        libnotify

        # Pavucontrol is how we'll manage audio devices
        pavucontrol

        # SwayIdle will be our idle daemon
        swayidle

        # imv and mpv will be our media programs
        imv
        mpv
    ];
}
