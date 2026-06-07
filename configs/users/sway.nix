# Configure a sway-based desktop environment
{ config, pkgs, ... }:
let
    colors_sway = {
        base03 = "#002B36";
        base02 = "#073642";
        base01 = "#586E75";
        base00 = "#657B83";
        base0 = "#839496";
        base1 = "#93A1A1";
        base2 = "#EEE8D5";
        base3 = "#FDF6E3";
        yellow = "#B58900";
        orange = "#CB4B16";
        red = "#DC322F";
        magenta = "#D33682";
        violet = "#6C71C4";
        blue = "#268BD2";
        cyan = "#2AA198";
        green = "#859900";
        black = "#000000";
    };
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

    # Main Sway configuration
    wayland.windowManager.sway = {
        enable = true;
        config = {
            modifier = "Mod4";
            menu = "rofi -show drun";
            terminal = "foot";
            colors = {
                background = colors_sway.red;
                focused = {
                    background = colors_sway.base02;
                    border = colors_sway.cyan;
                    childBorder = colors_sway.cyan;
                    indicator = colors_sway.yellow;
                    text = colors_sway.base0;
                };
                focusedInactive = {
                    background = colors_sway.base02;
                    border = colors_sway.base01;
                    childBorder = colors_sway.base01;
                    indicator = colors_sway.yellow;
                    text = colors_sway.base0;
                };
                unfocused = {
                    background = colors_sway.base03;
                    border = colors_sway.base01;
                    childBorder = colors_sway.base01;
                    indicator = colors_sway.yellow;
                    text = colors_sway.base01;
                };
            };
            defaultWorkspace = "workspace number 1";
            floating = {
                border = 2;
                titlebar = false;
            };
            focus = {
                followMouse = "yes";
                mouseWarping = "container";
            };
            fonts = {
                names = [ "Noto Sans" ];
                size = 11.0;
            };
            gaps = {
                inner = 4;
                outer = 0;
            };
            input = {
                "*" = {
                    accel_profile = "flat";
                    xkb_numlock = "enabled";
                };
            };
            window = {
                border = 2;
                titlebar = false;
            };
        };
        extraConfig = ''
            titlebar_border_thickness 2
            include conf.d/*
            '';
        extraOptions = [ "--unsupported-gpu" ];
    };

    # Configure theming for GUI applications
    home.pointerCursor = {
        enable = true;
        name = "Bibata-Modern-Classic";
        size = 24;
        package = pkgs.bibata-cursors;
        gtk.enable = true;
        sway.enable = true;
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
}
