{ config, pkgs, ... }:

{
    # Basic profile information
    home.username = "mason";
    home.homeDirectory = "/home/mason";

    # Configure all the main programs for the user profile
    programs = {
        git = {
            enable = true;
            lfs.enable = true;
            settings = {
                user = {
                    name = "Mason Davy";
                    email = "masonnosam11@gmail.com";
                    signingKey = "DE3598228AAC04284265509992D13BE032F7A4A4";
                };
                commit = {
                    gpgsign = true;
                };
                tag = {
                    gpgsign = true;
                };
                credential = {
                    credentialStore = "gpg";
                    helper = "/usr/bin/env git-credential-manager";
                };
                core = {
                    editor = "kak";
                };
            };
        };
    };

    # Configure theming for GUI applications
    home.pointerCursor= {
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

    # Let home manager manage itself and set the config version
    programs.home-manager.enable = true;
    home.stateVersion = "25.11";
}
