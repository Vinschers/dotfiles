#!/bin/python

import json
import os
import socket
import subprocess

# import time


def get_workspace_id(workspace_name):
    ws_id = int(workspace_name) % 10

    if ws_id == 0:
        return 10
    return ws_id


def run_cmd(cmd):
    return subprocess.run(cmd.split(), stdout=subprocess.PIPE).stdout


def get_json(active_ws_name):
    workspaces = json.loads(run_cmd("hyprctl workspaces -j"))
    monitors = json.loads(run_cmd("hyprctl monitors -j"))

    status = [[0] * 10 for _ in range(0, len(monitors))]
    monitor_name_id = {monitor["name"]: monitor["id"] for monitor in monitors}

    for ws in workspaces:
        mon_id = monitor_name_id[ws["monitor"]]
        ws_id = get_workspace_id(ws["name"])

        active_ws = monitors[mon_id]["activeWorkspace"]["id"]

        if ws["name"] == active_ws_name or int(ws["name"]) == active_ws:
            status[mon_id][ws_id - 1] = 2
            continue

        if ws["windows"] == 0:
            continue

        status[mon_id][ws_id - 1] = 1

    return json.dumps(status)


def main():
    hyprland_instance = os.getenv("HYPRLAND_INSTANCE_SIGNATURE")
    path = f"/tmp/hypr/{hyprland_instance}/.socket2.sock"

    if not os.path.exists(path):
        return

    print(get_json("1"), flush=True)

    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
        client.connect(path)

        socket_file = client.makefile(mode="r", buffering=1)

        while True:
            line = socket_file.readline().strip()

            if not line:
                break

            # start_time = time.time()

            event, args = line.split(">>")

            if event == "focusedmon":
                active = args.split(",")[1]
            elif event == "workspace":
                active = args
            else:
                continue

            print(get_json(active), flush=True)

            # diff_time = int((time.time() - start_time) * 1000)
            # run_cmd(f"notify-send {diff_time} ms")


if __name__ == "__main__":
    main()
