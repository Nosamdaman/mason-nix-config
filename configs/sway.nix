# My Sway Configuration
{ config, pkgs, ... }:
let
    colors = {
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
in {
    # Main Sway configuration
    wayland.windowManager.sway = {
        enable = true;
        config = {
            modifier = "Mod4";
            menu = "rofi -show drun";
            terminal = "alacritty";
            focus = {
                followMouse = "yes";
                mouseWarping = "container";
            };
            colors = {
                background = colors.black;
                focused = {
                    background = colors.base02;
                    border = colors.cyan;
                    childBorder = colors.cyan;
                    indicator = colors.yellow;
                    text = colors.base0;
                };
                focusedInactive = {
                    background = colors.base02;
                    border = colors.base01;
                    childBorder = colors.base01;
                    indicator = colors.yellow;
                    text = colors.base0;
                };
                unfocused = {
                    background = colors.base03;
                    border = colors.base01;
                    childBorder = colors.base01;
                    indicator = colors.yellow;
                    text = colors.base01;
                };
            };
            input = {
                "*" = {
                    accel_profile = "flat";
                    xkb_numlock = "enabled";
                };
            };
        };
        extraConfig = "include conf.d/*";
        extraOptions = [ "--unsupported-gpu" ];
    };
}
