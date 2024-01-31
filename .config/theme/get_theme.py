import sys
import os
import json

import pywal
from material_color_utilities_python import Image, themeFromImage, hexFromArgb


def get_colors(path, light=False):
    return pywal.colors.get(path, backend="haishoku", light=light, sat="0.5")


def get_material(path, mode="dark"):
    img = Image.open(path)

    basewidth = 256
    wpercent = basewidth / float(img.size[0])
    hsize = int((float(img.size[1]) * float(wpercent)))

    img = img.resize((basewidth, hsize), Image.Resampling.LANCZOS)

    material = themeFromImage(img).get("schemes", {}).get(mode).props
    material = {k: hexFromArgb(v) for k, v in material.items()}

    return material


def get_theme(path, mode):
    theme = get_colors(path, mode == "light")
    theme["special"] = theme.get("special", {}) | get_material(path, mode)

    theme["mode"] = mode

    return theme


def get_path_mode():
    if len(sys.argv) < 2:
        exit(1)

    path = sys.argv[1]

    if not os.path.isfile(path):
        exit(1)

    mode = "dark"
    if len(sys.argv) > 2 and sys.argv[2] in ["light", "dark"]:
        mode = sys.argv[2]

    return path, mode


def main():
    path, mode = get_path_mode()
    theme = get_theme(path, mode)

    home_dir = os.getenv("HOME", os.getenv("USERPROFILE", ""))
    config_dir = os.getenv("XDG_CONFIG_HOME", os.path.join(home_dir, ".config"))
    theme_path = os.path.join(config_dir, "theme/theme.json")

    wallpaper = theme.get("wallpaper", "")
    del theme["wallpaper"]

    with open(theme_path, 'w') as fp:
        json.dump(theme, fp, indent=4)

    print(wallpaper)


if __name__ == "__main__":
    main()
