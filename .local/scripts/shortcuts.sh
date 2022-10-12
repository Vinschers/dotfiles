#!/bin/sh

key="$1"

case "$key" in
    Return)
        "$TERMINAL"
        ;;
    Print)
        flameshot gui
        ;;
    Delete)
        lock
        ;;
    F1)
        pamixer -m && update_dwmblocks 4
        ;;
    F2)
        pamixer -ud 1 && update_dwmblocks 4
        ;;
    F3)
        pamixer -ui 1 && update_dwmblocks 4
        ;;
    a)
        sci add
        ;;
    b)
        "$BROWSER"
        ;;
    e)
        notify-send "$(colorpicker --short --one-shot --preview)"
        ;;
    j)
        books="$(find "$BIBLIOGRAPHY_DIRECTORY/book" -type f -printf "%f\n" | cut -d'.' -f -1)"
        selected_book="$(echo "$books" | dmenu -i -l 15)"

        PDF_PATH="$BIBLIOGRAPHY_DIRECTORY/book/$selected_book.pdf"
        if [ -n "$selected_book" ]
        then
            sioyek "$PDF_PATH" || zathura "$PDF_PATH"
        fi
        ;;
    k)
        sci
        ;;
    p)
        simple-scan
        ;;
    s)
        spotify
        ;;
    w)
        webcam
        ;;
    x)
        killall -SIGUSR1 sxhkd
        ;;

    *)
        notify-send "Unknown shortcut $key."
        ;;
esac
