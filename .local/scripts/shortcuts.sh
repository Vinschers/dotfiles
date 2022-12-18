#!/bin/sh

key="$1"

case "$key" in
    Return)
        "$TERMINAL"
        ;;
    Print)
        flameshot gui
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
    d)
        sh -c "cd $ACADEMIC_DIRECTORY/unicamp/disciplinas; $TERMINAL"
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
    p)
        project="$(ls -1 "$ACADEMIC_DIRECTORY/projects" | dmenu -i -l 10)"
        [ -n "$project" ] && cd "$ACADEMIC_DIRECTORY/projects/$project" && "$TERMINAL"
        ;;
    s)
        spot-cli --prompt
        ;;
    w)
        webcam
        ;;
    x)
        killall -SIGUSR1 sxhkd
        ;;

    *)
        notify-send -u low "Unknown shortcut $key."
        ;;
esac
