{ config, pkgs, ... }:

{
    home.username = "mason";
    home.homeDirectory = "/home/mason";

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

    programs.home-manager.enable = true;

    home.stateVersion = "25.11";
}
