import os
import subprocess
import pathlib
import json
import time
import psutil

import pywal


def checkIfProcessRunning(processName):
    """
    Check if there is any running process that contains the given name processName.
    """
    # Iterate over the all the running process
    for proc in psutil.process_iter():
        try:
            # Check if process name contains the given name string.
            if processName.lower() in proc.name().lower():
                return True
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass
    return False


def _export_default(theme, wal_cache_dir):
    default_path = os.path.join(pywal.settings.MODULE_DIR, "templates")

    for file in os.scandir(default_path):
        if file.name != ".DS_Store" and not file.name.endswith(".swp"):
            pywal.export.template(
                theme, file.path, os.path.join(wal_cache_dir, file.name)
            )


def _export_user(theme, templates_dir, config_dir):
    for root, _, files in os.walk(templates_dir, topdown=False):
        for name in files:
            full_path = os.path.join(root, name)
            template_path = full_path.replace(f"{templates_dir}/", "")

            output_path = os.path.join(config_dir, template_path)

            pywal.export.template(theme, full_path, output_path)


def run(cmd=""):
    if cmd:
        print(cmd)
        subprocess.run(cmd.split())


def update_shell(config_dir):
    shell_theme = os.path.join(config_dir, "shell/theme.sh")
    run(f"chmod +x {shell_theme}")
    run("killall -s USR1 zsh")


def update_spotify():
    run("spicetify config color_scheme Pywal")

    if checkIfProcessRunning("spotify"):
        p = subprocess.Popen("spicetify -s watch -q".split())
        time.sleep(1)
        p.terminate()


def update_gtk_qt(config_dir, data_dir):
    script = "/opt/oomox/plugins/theme_oomox/change_color.sh"
    oomox_colors = os.path.join(config_dir, "theme/oomox-colors")
    themes_dir = os.path.join(data_dir, "themes")

    cmd = f"{script} --target-dir {themes_dir} --output wal {oomox_colors}"
    run(cmd)

    run("gsettings set org.gnome.desktop.interface gtk-theme ''")
    time.sleep(1)
    run("gsettings set org.gnome.desktop.interface gtk-theme wal")


def main():
    home_dir = os.getenv("HOME", os.getenv("USERPROFILE", ""))
    config_dir = os.getenv("XDG_CONFIG_HOME", os.path.join(home_dir, ".config"))
    cache_dir = os.getenv("XDG_CACHE_HOME", os.path.join(home_dir, ".cache"))
    data_dir = os.getenv("XDG_DATA_HOME", os.path.join(home_dir, ".local/share"))

    theme_path = os.path.join(config_dir, "theme/theme.json")
    wal_cache_dir = os.path.join(cache_dir, "wal")
    templates_dir = os.path.join(config_dir, "theme/templates")

    with open(theme_path) as fp:
        theme = json.load(fp)

    if not theme:
        exit(1)

    theme["wallpaper"] = ""

    pathlib.Path(templates_dir).mkdir(parents=True, exist_ok=True)
    pathlib.Path(wal_cache_dir).mkdir(parents=True, exist_ok=True)

    theme = pywal.export.flatten_colors(theme)

    _export_default(theme, wal_cache_dir)
    _export_user(theme, templates_dir, config_dir)

    update_shell(config_dir)
    run("killall -s USR1 cava")
    update_spotify()

    update_gtk_qt(config_dir, data_dir)

    run("hyprctl reload")


if __name__ == "__main__":
    main()
