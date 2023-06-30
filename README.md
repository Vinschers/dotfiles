# Installation

```sh
git clone --bare https://github.com/Vinschers/dotfiles.git $HOME/.dotfiles-git
git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} rm $HOME/{}
git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME checkout
git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME config --local status.showUntrackedFiles no
```
## Enable screen share by using a virtual camera
Just install OBS.

```sh
sudo pacman -S obs-studio
```

## Change GitHub to use SSH instead of HTTPS
First, configure ssh access following [this](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) tutorial. Then, run

```sh
dotfiles remote set-url origin git@github.com:Vinschers/dotfiles.git
```

## Install waybar
```sh
git clone https://github.com/LukashonakV/cava
cd cava
meson setup build
meson compile -C build
meson install -C build
cd ..
rm -rf cava
yay --editmenu waybar-git
```
Then, you need to add the flag `-Dexperimental=true` to the `meson` command, inside the `build` function.

## Setup wi-fi
First, start the iwd service with `sudo systemctl enable iwd`. If the internet does not work immediately, try configuring DHCP. To do so, install the `dhcpcd` and run `sudo systemctl enable dhcpcd.service`.

## Fix spotify permissions to use spicetify
Just run the following

```sh
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
```

# Showcase
![](/.local/share/assets/picture1.png)
![](/.local/share/assets/picture2.png)
