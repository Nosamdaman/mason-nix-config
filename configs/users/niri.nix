# Configure a niri-based desktop environment
{ config, pkgs, ... }: let
    colors_foot = {
        base03 = "002B36";
        base02 = "073642";
        base01 = "586E75";
        base00 = "657B83";
        base0 = "839496";
        base1 = "93A1A1";
        base2 = "EEE8D5";
        base3 = "FDF6E3";
        yellow = "B58900";
        orange = "CB4B16";
        red = "DC322F";
        magenta = "D33682";
        violet = "6C71C4";
        blue = "268BD2";
        cyan = "2AA198";
        green = "859900";
        black = "000000";
    };
in {
    # Import the base config
    imports = [ ./base.nix ];

    # Configure theming for GUI applications
    home.pointerCursor = {
        enable = true;
        name = "Bibata-Modern-Classic";
        size = 24;
        package = pkgs.bibata-cursors;
        gtk.enable = true;
        dotIcons.enable = true;
        x11.enable = true;
    };
    gtk = {
        enable = true;
        colorScheme = "dark";
        theme = {
            name = "Breeze-Dark";
            package = pkgs.kdePackages.breeze-gtk;
        };
        iconTheme = {
            name = "breeze-dark";
            package = pkgs.kdePackages.breeze-icons;
        };
        gtk4.theme = config.gtk.theme;
    };

    # Terminal emulator configuration
    programs.foot = {
        enable = true;
        settings = {
            main = {
                shell = "fish";
                font = "FiraCode Nerd Font:size=12:fontfeatures=zero:fontfeatures=ss04";
                bold-text-in-bright = "no";
            };
            mouse = {
                hide-when-typing = true;
            };
            colors-dark = {
                alpha = "0.8";
                blur = "true";
                foreground = colors_foot.base0;
                background = colors_foot.base03;
                regular0 = colors_foot.base02;
                regular1 = colors_foot.red;
                regular2 = colors_foot.green;
                regular3 = colors_foot.yellow;
                regular4 = colors_foot.blue;
                regular5 = colors_foot.magenta;
                regular6 = colors_foot.cyan;
                regular7 = colors_foot.base2;
                bright0 = colors_foot.base03;
                bright1 = colors_foot.orange;
                bright2 = colors_foot.base01;
                bright3 = colors_foot.base00;
                bright4 = colors_foot.base0;
                bright5 = colors_foot.violet;
                bright6 = colors_foot.base1;
                bright7 = colors_foot.base3;
            };
        };
    };

    # Configure niri
    xdg.configFile.niri-base = {
        source = ../../resources/niri-base.kdl;
        target = "niri/base.kdl";
    };

    # Configure mako
    xdg.configFile.mako = {
        text = ''
            default-timeout=5000
            font=sans 12
            text-color=#93A1A1
            background-color=#002B36BF
            height=200
            width=400
            border-color=#2AA198
            border-size=1
            border-radius=6
            icons=1
            icon-path=${pkgs.kdePackages.breeze-icons}/share/icons/breeze-dark
        '';
        target = "mako/config";
    };

    # Configure Rofi
    xdg.configFile.rofi = {
        source = ../../resources/config.rasi;
        target = "rofi/config.rasi";
    };
}
