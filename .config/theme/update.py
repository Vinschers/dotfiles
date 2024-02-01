from os import scandir, walk, getenv
from os.path import join
import pathlib
import json
import subprocess

import pywal


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


def get_dirs():
    home_dir = getenv("HOME", getenv("USERPROFILE", ""))
    config_dir = getenv("XDG_CONFIG_HOME", join(home_dir, ".config"))
    cache_dir = getenv("XDG_CACHE_HOME", join(home_dir, ".cache"))

    wal_cache_dir = join(cache_dir, "wal")
    templates_dir = join(config_dir, "theme/templates")

    pathlib.Path(templates_dir).mkdir(parents=True, exist_ok=True)
    pathlib.Path(wal_cache_dir).mkdir(parents=True, exist_ok=True)

    return config_dir, templates_dir, wal_cache_dir


def main():
    config_dir, templates_dir, wal_cache_dir = get_dirs()

    with open(join(config_dir, "theme/theme.json")) as fp:
        theme = json.load(fp)

    if not theme:
        exit(1)

    flatten_theme = pywal.export.flatten_colors(theme)

    _export_default(flatten_theme, wal_cache_dir)
    _export_user(flatten_theme, templates_dir, config_dir)

    subprocess.run(join(config_dir, "theme/update.sh").split())
    pywal.sequences.send(theme)


if __name__ == "__main__":
    main()
