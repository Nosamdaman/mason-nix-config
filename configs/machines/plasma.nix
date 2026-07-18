{ pkgs, ... }: {
    imports = [ ./desktop.nix ];

    # Enable plasma6 and the rest of the software related to the environment we want
    services = {
        displayManager.plasma-login-manager.enable = true;
        desktopManager.plasma6.enable = true;
    };

    # Install the remaining packages for our desktop environment
    environment.systemPackages = with pkgs; [
        # Foot will be our terminal emulator
        foot
    ];
}
