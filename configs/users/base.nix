# My base Home-Manager configuration
{ ... }: {
    # Set the basic user profile information
    home.username = "mason";
    home.homeDirectory = "/home/mason";

    # Enable shell integrations
    home.shell = {
        enableBashIntegration = true;
        enableFishIntegration = true;
    };

    # Set up the automatic management of our XDG user directories
    xdg.enable = true;
    xdg.userDirs = {
        enable = true;
        createDirectories = true;
    };

    # Configure all programs with pre-defined configuration options
    programs = {
        # Let home manager manage itself
        home-manager.enable = true;

        # Manage our bash config; this is pretty simple, we just set some nice ls aliases and a simple PS1
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

        # Manage our fish config; this is a bit more involved than the bash one. In addition to the aliases, we'll also
        # set the dircolors variable for our solarized shell.
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

        # Configure git
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

    # Install any extra config files
    xdg.configFile = {
        # This is our fish color theme, it's just the default solarized dark theme serialized out
        fish_frozen_theme = {
            source = ../../resources/fish_frozen_theme.fish;
            target = "fish/conf.d/fish_frozen_theme.fish";
        };

        # This is my custom version of awesome dircolors solarized theme by Seebi
        #
        # https://github.com/seebi/dircolors-solarized
        #
        # The only difference is that mine has the bold attribute set properly so bright colors aren't displated when
        # not intended.
        dircolors-solarized-dark = {
            source = ../../resources/dircolors.ansi-dark;
            target = "dircolors/solarized-dark";
        };

        # This is my tig config file
        tigrc = {
            source = ../../resources/tigrc;
            target = "tig/config";
        };
    };

    # DO NOT TOUCH!
    home.stateVersion = "26.05";
}
