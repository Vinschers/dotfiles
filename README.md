# Installation

```sh
git clone --bare https://github.com/Vinschers/dotfiles.git $HOME/.dotfiles-git
git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} rm $HOME/{}
git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME checkout
git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME config --local status.showUntrackedFiles no
```
## Enable screen share by using a virtual camera
Just install OBS and xdg-desktop-portal-wlr.

```sh
sudo pacman -S obs-studio xdg-desktop-portal-wlr
```

## Change GitHub to use SSH instead of HTTPS
First, configure ssh access following [this](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) tutorial. Then, run

```sh
dotfiles remote set-url origin git@github.com:Vinschers/dotfiles.git
```

## Fix spotify permissions to use spicetify
Just run the following

```sh
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
```

# Showcase
![](/.scripts/pictures/picture1.png)
![](/.scripts/pictures/picture2.png)
