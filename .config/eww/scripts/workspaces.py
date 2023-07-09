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


def get_workspace_name(mon_id, ws_id):
    return 10 * mon_id + ws_id


def run_cmd(cmd):
    return subprocess.run(cmd.split(), stdout=subprocess.PIPE).stdout


def get_json():
    workspaces = json.loads(run_cmd("hyprctl workspaces -j"))
    monitors = json.loads(run_cmd("hyprctl monitors -j"))

    status = []
    for mon_id in range(0, len(monitors)):
        status.append([])

        for ws_id in range(1, 11):
            status[-1].append({"status": 0, "id": get_workspace_name(mon_id, ws_id)})

    monitor_name_id = {monitor["name"]: monitor["id"] for monitor in monitors}

    for ws in workspaces:
        mon_id = monitor_name_id[ws["monitor"]]
        ws_id = get_workspace_id(ws["name"])

        active_ws = monitors[mon_id]["activeWorkspace"]["id"]

        if int(ws["name"]) == active_ws:
            status[mon_id][ws_id - 1]["status"] = 2
            continue

        if ws["windows"] == 0:
            continue

        status[mon_id][ws_id - 1]["status"] = 1

    return json.dumps(status)


def main():
    hyprland_instance = os.getenv("HYPRLAND_INSTANCE_SIGNATURE")
    path = f"/tmp/hypr/{hyprland_instance}/.socket2.sock"

    if not os.path.exists(path):
        return

    print(get_json(), flush=True)

    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
        client.connect(path)

        socket_file = client.makefile(mode="r", buffering=1)

        while True:
            line = socket_file.readline().strip()

            if not line:
                break

            # start_time = time.time()

            event, _ = line.split(">>")

            if event != "focusedmon" and event != "workspace":
                continue

            print(get_json(), flush=True)

            # diff_time = int((time.time() - start_time) * 1000)
            # run_cmd(f"notify-send {diff_time} ms")


if __name__ == "__main__":
    main()
