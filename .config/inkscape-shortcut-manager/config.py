import os
import subprocess


def open_editor(filename):
    terminal = os.environ["TERMINAL"]
    editor = os.environ["EDITOR"]

    subprocess.run(
        [
            terminal,
            "-e",
            editor,
            f"{filename}",
        ]
    )


def latex_document(latex):
    return (
        r"""
        \documentclass[12pt,border=12pt]{standalone}

        \usepackage[utf8]{inputenc}
        \usepackage[T1]{fontenc}
        \usepackage{textcomp}
        \usepackage{amsmath, amsfonts, mathtools, amsthm, amssymb, lipsum, pgfplots, siunitx}

        \begin{document}
    """
        + latex
        + r"\end{document}"
    )


config = {
    "rofi_theme": "~/.config/rofi/ribbon.rasi",
    "font": "monospace",
    "font_size": 16,
    "open_editor": open_editor,
    "latex_document": latex_document,
}
