#!/bin/sh

echo "$(($(checkupdates | wc -l) + $(yay --devel -Qum 2>/dev/null | wc -l)))"
