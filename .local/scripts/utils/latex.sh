#!/bin/sh

file_name="tex2im_temp"

create_pdf () {
	tex_file="$file_name.tex"

	equation="$(vipe --suffix tex)"

	tex="$(echo "\documentclass[12pt]{article}
\usepackage{color}
\usepackage{amsmath}
\pagestyle{empty}
\pagecolor{white}
\begin{document}{
\color{black}
\begin{eqnarray*}
$equation
\end{eqnarray*}
}\end{document}")"

	echo "$tex" | sed -e "s/\r//g" > "$tex_file"
	pdflatex -interaction=nonstopmode "$tex_file" 2>&1 > /dev/null
	# pdflatex -interaction=nonstopmode "$tex_file"
}

convert_png () {
	border=10
	bg_color="white"
	resolution=1500

	convert -quiet -trim -border $border -bordercolor $bg_color +adjoin -density $resolution "$file_name.pdf" "$file_name.png"
}

copy_to_clipboard () {
	xclip -selection clipboard -t image/png -i "$file_name.png"
}

clean_dir () {
	rm "$file_name".*
}

create_pdf && convert_png && copy_to_clipboard && notify-send "Copied LaTeX output to clipboard." && clean_dir
