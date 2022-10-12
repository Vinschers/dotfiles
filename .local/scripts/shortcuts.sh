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
    a)
        sci add
        ;;
    b)
        "$BROWSER"
        ;;
    d)
        pamixer -ud 1 && update_dwmblocks 4
        ;;
    e)
        notify-send "$(colorpicker --short --one-shot --preview)"
        ;;
    i)
        pamixer -ui 1 && update_dwmblocks 4
        ;;
    j)
        books="$(find -L "$BIBLIOGRAPHY_DIRECTORY/book" -type f -printf "%f\n" | cut -d'.' -f -1)"
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
    m)
        pamixer -m && update_dwmblocks 4
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
