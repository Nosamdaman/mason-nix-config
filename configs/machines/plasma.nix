{ pkgs, ... }: {
    imports = [ ./desktop.nix ];

    # Enable plasma6 and the rest of the software related to the environment we want
    services = {
        displayManager.plasma-login-manager.enable = true;
        desktopManager.plasma6.enable = true;
    };
}
