from os import scandir, walk, getenv
from os.path import join
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
    default_path = join(pywal.settings.MODULE_DIR, "templates")

    for file in scandir(default_path):
        if file.name != ".DS_Store" and not file.name.endswith(".swp"):
            pywal.export.template(theme, file.path, join(wal_cache_dir, file.name))


def _export_user(theme, templates_dir, config_dir):
    for root, _, files in walk(templates_dir, topdown=False):
        for name in files:
            full_path = join(root, name)
            template_path = full_path.replace(f"{templates_dir}/", "")

            output_path = join(config_dir, template_path)

            pywal.export.template(theme, full_path, output_path)


def run(cmd=""):
    if cmd:
        print(cmd)
        subprocess.run(cmd.split())


def update_spotify():
    run("spicetify config color_scheme Pywal")

    if checkIfProcessRunning("spotify"):
        p = subprocess.Popen("spicetify -s watch -q".split())
        time.sleep(1)
        p.terminate()


def update_gtk_qt(config_dir, data_dir):
    script = "/opt/oomox/plugins/theme_oomox/change_color.sh"
    oomox_colors = join(config_dir, "oomox/oomox-colors")
    themes_dir = join(data_dir, "themes")

    cmd = f"{script} --target-dir {themes_dir} --output wal {oomox_colors}"
    run(cmd)

    run("gsettings set org.gnome.desktop.interface gtk-theme ''")
    run("gsettings set org.gnome.desktop.interface gtk-theme wal")


def update(theme, config_dir, data_dir):
    pywal.sequences.send(theme)
    run("killall -s USR1 cava")
    run("hyprctl reload")
    update_spotify()
    update_gtk_qt(config_dir, data_dir)


def get_dirs():
    home_dir = getenv("HOME", getenv("USERPROFILE", ""))
    config_dir = getenv("XDG_CONFIG_HOME", join(home_dir, ".config"))
    cache_dir = getenv("XDG_CACHE_HOME", join(home_dir, ".cache"))
    data_dir = getenv("XDG_DATA_HOME", join(home_dir, ".local/share"))

    wal_cache_dir = join(cache_dir, "wal")
    templates_dir = join(config_dir, "theme/templates")

    pathlib.Path(templates_dir).mkdir(parents=True, exist_ok=True)
    pathlib.Path(wal_cache_dir).mkdir(parents=True, exist_ok=True)

    return config_dir, data_dir, templates_dir, wal_cache_dir


def main():
    config_dir, data_dir, templates_dir, wal_cache_dir = get_dirs()

    with open(join(config_dir, "theme/theme.json")) as fp:
        theme = json.load(fp)

    if not theme:
        exit(1)

    flatten_theme = pywal.export.flatten_colors(theme)

    _export_default(flatten_theme, wal_cache_dir)
    _export_user(flatten_theme, templates_dir, config_dir)

    update(theme, config_dir, data_dir)


if __name__ == "__main__":
    main()
