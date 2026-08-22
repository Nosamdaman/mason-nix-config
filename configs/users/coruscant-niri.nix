# Specific configuration options for the niri desktop on coruscant
{ pkgs, ... }: {
    # Import the base config
    imports = [ ./niri.nix ];

    # Configure the base config
    xdg.configFile.niri = {
        text = ''
            include "base.kdl"

            output "DP-1" {
                mode "3440x1440@143.975"
                variable-refresh-rate on-demand=true
            }

            spawn-at-startup "swayidle" "-w" "timeout" "300" "niri msg action power-off-monitors"
        '';
        target = "niri/config.kdl";
    };
}
