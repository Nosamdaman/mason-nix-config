#!/usr/bin/env python

"""Module for automatically toggling Sway's VRR status"""

import argparse
import json
import os
import shutil
import subprocess
import sys


def _cli():
    parser = argparse.ArgumentParser(
        prog=os.path.basename(sys.argv[0]),
        description="Automatically manage VRR state in Sway",
        epilog="""
        This program subscribes to Sway in order to manage the VRR state of all outputs. VRR will be toggled on and off
        as applications enter and leave fullscreen on the outputs which supprt VRR.
        """,
    )
    args = vars(parser.parse_args())
    args["parser"] = parser
    _main(**args)


def _main(parser: argparse.ArgumentParser):
    # Get the path to the executables we'll be calling into
    swaymsg_file = shutil.which("swaymsg")
    if swaymsg_file is None:
        parser.error("\"swaymsg\" executable not found, VRR cannot be managed")
    notify_send_file = shutil.which("notify-send")
    if notify_send_file is None:
        parser.error("\"notify-send\" executable not found, VRR cannot be managed")

    # Subscribe to the Sway message service
    proc = subprocess.Popen([swaymsg_file, "-t", "subscribe", "-m", "[ \"window\" ]"], stdout=subprocess.PIPE)
    assert proc.stdout is not None, "This shouldn't be possible"

    # Loop to parse the messages
    while True:
        # Read the event data
        event_data = json.loads(proc.stdout.readline())

        # We only need to do something if a window's focus or fullscreen state changed
        if event_data["change"] in ["focus", "fullscreen_mode"]:
            # Get the name of the currently active output and it's VRR state
            outputs = json.loads(subprocess.run([swaymsg_file, "-t", "get_outputs"], stdout=subprocess.PIPE).stdout)
            cur_output = None
            vrr_enabled = None
            for output in outputs:
                if output["focused"]:
                    cur_output = output["name"]
                    match output["adaptive_sync_status"]:
                        case "enabled":
                            vrr_enabled = True
                        case "disabled":
                            vrr_enabled = False
                        case _:
                            raise RuntimeError("This shouldn't be possible")
            assert cur_output is not None, "This shouldn't be possible"
            assert vrr_enabled is not None, "This shouldn't be possible"

            # Get the fullscreen state of the changed window
            is_fullscreen = event_data["container"]["fullscreen_mode"] != 0

            # Update the VRR status if necessary
            if is_fullscreen and not vrr_enabled:
                subprocess.run([swaymsg_file, "output", cur_output, "adaptive_sync", "1"])
                subprocess.run([
                    notify_send_file,
                    "--urgency=normal",
                    "--expire-time=5000",
                    "VRR Enabled",
                    "VRR was enabled automatically",
                ])
            elif not is_fullscreen and vrr_enabled:
                subprocess.run([swaymsg_file, "output", cur_output, "adaptive_sync", "0"])
                subprocess.run([
                    notify_send_file,
                    "--urgency=normal",
                    "--expire-time=5000",
                    "VRR Disabled",
                    "VRR was disabled automatically",
                ])

    # Exit successfully
    parser.exit()


if __name__ == "__main__":
    _cli()
