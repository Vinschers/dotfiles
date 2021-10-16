Please note that this README file is shared with all my rice and config repositories, so there is a section for each of them.

# [dotfiles](https://github.com/Vinschers/dotfiles)
## Installation

```sh
git clone --bare https://github.com/Vinschers/dotfiles.git $HOME/.dotfiles-git
git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} rm $HOME/{}
git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME checkout
git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME config --local status.showUntrackedFiles no
```

# [rice-xfce4](https://github.com/Vinschers/rice-xfce4)
## Installation

```sh
git clone --bare https://github.com/Vinschers/rice-xfce4.git $HOME/.rice-xfce4-git
git --git-dir=$HOME/.rice-xfce4-git/ --work-tree=$HOME checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} rm $HOME/{}
git --git-dir=$HOME/.rice-xfce4-git/ --work-tree=$HOME checkout
git --git-dir=$HOME/.rice-xfce4-git/ --work-tree=$HOME config --local status.showUntrackedFiles no
```
## Dependencies
- xf86-video-intel
- xorg
- xorg-xinit
- xfce4
- xfce4-goodies
- gvfs
- arc-gtk-theme
- arc-icon-theme
- noto-fonts
- [matcha-gtk-theme](https://vinceliuice.github.io/theme-matcha.html)

## Setup
To run xfce4, don't forget to add `exec startxfce4` to your `.xinitrc`
