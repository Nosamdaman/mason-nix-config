# Specific configuration options for the niri desktop on coruscant
{ pkgs, ... }: {
    # Import the base config
    imports = [ ./niri.nix ];

    # Configure the base config
    xdg.configFile.niri = {
        text = ''
            include "base.kdl"

            spawn-at-startup "swayidle" "-w" "timeout" "300" "niri msg action power-off-monitors"
        '';
        target = "niri/config.kdl";
    };
}
