{ config, pkgs, ... }:

{
    # Set our username and home directory
    home.username = "mason";
    home.homeDirectory = "/home/mason";

    home.shell.enableFishIntegration = true;

    # Set up the automatic management of our XDG user directories
    xdg.enable = true;
    xdg.userDirs = {
        enable = true;
        createDirectories = true;
    };

    # Install and configure all programs with pre-defined config options
    programs = {
        home-manager.enable = true;
        bash = {
            enable = true;
            shellAliases = {
                ls = "ls --color=auto --file-type --group-directories-first";
                ll = "ls -l --human-readable --time-style=long-iso";
                la = "ll -a";
            };
            initExtra = ''
            PS1='[\u@\h \W]\$ '
            '';
        };
        fish = {
            enable = true;
            shellAliases = {
                ls = "ls --color=auto --file-type --group-directories-first";
                ll = "ls -l --human-readable --time-style=long-iso";
                la = "ll -a";
            };
            generateCompletions = true;
            interactiveShellInit = ''
            eval (dircolors --c-shell $XDG_CONFIG_HOME/dircolors/solarized-dark) | true
            '';
        };
        kakoune.enable = true;
        man = {
            enable = true;
            man-db.enable = true;
        };
        git = {
            enable = true;
            lfs.enable = true;
            settings = {
                user = {
                    name = "Mason Davy";
                    email = "mason.davy@etegent.com";
                    signingKey = "CECCD220F85C545A";
                };
                commit = {
                    gpgsign = true;
                };
                tag = {
                    gpgsign = true;
                };
                credential = {
                    credentialStore = "gpg";
                    helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
                };
                core = {
                    editor = "kak";
                };
            };
        };
        gpg.enable = true;
    };

    # Install all non-configurable packages
    home.packages = with pkgs; [
        pass-wayland
        tig
    ];

    # Enable any necessary user services
    services = {
        gpg-agent = {
            enable = true;
            pinentry = {
                package = pkgs.pinentry-all;
                program = "pinentry-curses";
            };
        };
    };

    # Install any extra config files
    xdg.configFile = {
        fish_frozen_theme = {
            source = ../../resources/fish_frozen_theme.fish;
            target = "fish/conf.d/fish_frozen_theme.fish";
        };
        dircolors-solarized-dark = {
            source = ../../resources/dircolors.ansi-dark;
            target = "dircolors/solarized-dark";
        };
    };


    home.stateVersion = "26.05";
}
