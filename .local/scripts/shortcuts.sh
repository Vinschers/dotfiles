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
        books="$(find -L "$ACADEMIC_DIRECTORY/bibliography/book" -type f -printf "%f\n" | cut -d'.' -f -1)"
        selected_book="$(echo "$books" | dmenu -i -l 15)"

        PDF_PATH="$ACADEMIC_DIRECTORY/bibliography/book/$selected_book.pdf"
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
        project="$(ls -1 "$ACADEMIC_DIRECTORY/projects" | dmenu -i -l 10)"
        [ -n "$project" ] && cd "$ACADEMIC_DIRECTORY/projects/$project" && "$TERMINAL"
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
