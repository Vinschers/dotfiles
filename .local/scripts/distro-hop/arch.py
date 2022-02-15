import os

#with open("/home/scherer/.local/scripts/distro-hop/pacman_full") as f:
#  for line in f:
#    os.system(f"sudo pacman -S --needed --noconfirm {line}")

with open("/home/scherer/.local/scripts/distro-hop/yay_full") as f:
  for line in f:
    os.system(f"yay -S {line}")
