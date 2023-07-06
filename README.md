# Installation

```sh
curl -O https://raw.githubusercontent.com/Vinschers/dotfiles/master/.config/setup/setup.sh
chmod +x setup.sh
./setup.sh
```

## Change GitHub to use SSH instead of HTTPS
First, configure ssh access following [this](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) tutorial. Then, run

```sh
dotfiles remote set-url origin git@github.com:Vinschers/dotfiles.git
```

## Setup wi-fi
First, start the iwd service with `sudo systemctl enable iwd`. If the internet does not work immediately, try configuring DHCP. To do so, install the `dhcpcd` and run `sudo systemctl enable dhcpcd.service`.


# Showcase
![](/.local/share/assets/picture1.png)
![](/.local/share/assets/picture2.png)
