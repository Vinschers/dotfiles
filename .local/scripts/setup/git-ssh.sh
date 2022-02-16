#!/bin/sh

echo -n "Email: "
read email

ssh-keygen -t ed25519 -C "$email" -N "" -f "$HOME/.ssh/id_ed25519"

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/id_ed25519

echo -e "Add the key in ~/.ssh/id_ed25519 to your Git account\nKey:\n\n"
cat ~/.ssh/id_ed25519.pub
