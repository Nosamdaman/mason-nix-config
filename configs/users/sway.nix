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
                modifier = "Mod4";
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
            keybindings = let
                modifier = "Mod4";
                menu = "rofi -show-icons -show drun -run-command \"uwsm app -- {cmd}\"";
                terminal = "uwsm app -- foot";
            in {
                "${modifier}+Return" = "exec ${terminal}";
                "${modifier}+Space" = "exec ${menu}";

                "${modifier}+q" = "kill";

                "${modifier}+Left" = "focus left";
                "${modifier}+Right" = "focus right";
                "${modifier}+Up" = "focus up";
                "${modifier}+Down" = "focus down";
                "${modifier}+Shift+Left" = "move left";
                "${modifier}+Shift+Right" = "move right";
                "${modifier}+Shift+Up" = "move up";
                "${modifier}+Shift+Down" = "move down";
                "${modifier}+Alt+Left" = "focus prev sibling";
                "${modifier}+Alt+Right" = "focus next sibling";
                "${modifier}+Alt+Up" = "focus parent";
                "${modifier}+Alt+Down" = "focus child";

                "${modifier}+h" = "focus left";
                "${modifier}+l" = "focus right";
                "${modifier}+k" = "focus up";
                "${modifier}+j" = "focus down";
                "${modifier}+Shift+h" = "move left";
                "${modifier}+Shift+l" = "move right";
                "${modifier}+Shift+k" = "move up";
                "${modifier}+Shift+j" = "move down";
                "${modifier}+Alt+h" = "focus prev sibling";
                "${modifier}+Alt+l" = "focus next sibling";
                "${modifier}+Alt+k" = "focus parent";
                "${modifier}+Alt+j" = "focus child";

                "${modifier}+Tab" = "focus next sibling";
                "${modifier}+Shift+Tab" = "focus prev sibling";

                "${modifier}+1" = "workspace number 1";
                "${modifier}+2" = "workspace number 2";
                "${modifier}+3" = "workspace number 3";
                "${modifier}+4" = "workspace number 4";
                "${modifier}+5" = "workspace number 5";
                "${modifier}+6" = "workspace number 6";
                "${modifier}+7" = "workspace number 7";
                "${modifier}+8" = "workspace number 8";
                "${modifier}+9" = "workspace number 9";
                "${modifier}+0" = "workspace number 10";

                "${modifier}+Shift+1" = "move container to workspace number 1";
                "${modifier}+Shift+2" = "move container to workspace number 2";
                "${modifier}+Shift+3" = "move container to workspace number 3";
                "${modifier}+Shift+4" = "move container to workspace number 4";
                "${modifier}+Shift+5" = "move container to workspace number 5";
                "${modifier}+Shift+6" = "move container to workspace number 6";
                "${modifier}+Shift+7" = "move container to workspace number 7";
                "${modifier}+Shift+8" = "move container to workspace number 8";
                "${modifier}+Shift+9" = "move container to workspace number 9";
                "${modifier}+Shift+0" = "move container to workspace number 10";

                "${modifier}+b" = "split horizontal";
                "${modifier}+v" = "split vertical";
                "${modifier}+semicolon" = "split toggle";
                "${modifier}+n" = "split none";

                "${modifier}+a" = "layout toggle split";
                "${modifier}+s" = "layout stacking";
                "${modifier}+d" = "layout tabbed";

                "${modifier}+f" = "floating toggle";
                "${modifier}+Shift+f" = "fullscreen";
                "${modifier}+Alt+f" = "focus mode_toggle";

                "${modifier}+r" = "mode resize";
            };
            startup = [
                { command = "uwsm app -- ${pkgs.swayidle}/bin/swayidle -w -C $XDG_CONFIG_HOME/swayidle/config"; }
                { command = "uwsm app -- ${pkgs.mako}/bin/mako"; }
                { command = "uwsm app -- ${pkgs.thunar}/bin/thunar --daemon"; }
            ];
            window = {
                border = 2;
                titlebar = false;
                commands = [
                    {
                        criteria = { app_id = ".*"; };
                        command = "border pixel 2";
                    }
                ];
            };
        };
        extraConfig = ''
            tiling_drag enable
            titlebar_border_thickness 2
            include /etc/sway/config.d/*
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

    # Configure swayidle
    xdg.configFile.swayidle = {
        text = ''
            timeout 300 '${pkgs.sway}/bin/swaymsg "output * power off"' resume '${pkgs.sway}/bin/swaymsg "output * power on"'
        '';
        target = "swayidle/config";
    };

    # Configure mako
    xdg.configFile.mako = {
        text = ''
            default-timeout=5000
            font=sans 12
            text-color=${colors_sway.base1}
            background-color=${colors_sway.base03}
            height=200
            width=400
            border-color=${colors_sway.cyan}
            border-size=2
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
