# Installation

```sh
git clone --bare https://github.com/Vinschers/dotfiles.git $HOME/.dotfiles-git
git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} rm $HOME/{}
git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME checkout
git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME config --local status.showUntrackedFiles no
```

# Showcase
![](/.local/scripts/pictures/picture1.png)
![](/.local/scripts/pictures/picture2.png)
