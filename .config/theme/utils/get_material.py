import material_color_utilities_python as mc
import json


def get_color_dict(color):
    return {"value": mc.argbFromHex(color), "blend": False}


def get_theme(color, custom_colors=[]):
    color = mc.argbFromHex(color)
    custom_colors = [get_color_dict(c) for c in custom_colors]

    theme = mc.themeFromSourceColor(color, custom_colors)

    custom_theme = theme.get("customColors", [])
    theme = theme.get("schemes", {}).get("dark", {})

    custom_theme = {
        mc.hexFromArgb(v["color"]["value"]): {
            k: mc.hexFromArgb(c) for k, c in v["dark"].items()
        }
        for v in custom_theme
    }

    theme = {k: mc.hexFromArgb(v) for k, v in theme.props.items()}
    theme["customColors"] = custom_theme

    print(json.dumps(theme, indent=4))


get_theme("#d3c6aa", ["#a7c080", "#83c092", "#7fbbb3", "#e67e80"])
