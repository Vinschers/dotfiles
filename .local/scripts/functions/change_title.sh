#!/bin/sh

change_title () {
	echo -n -e "\033]0;$1\007"
}

export change_title
