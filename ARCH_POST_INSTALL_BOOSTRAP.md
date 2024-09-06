### Note
- Provide more space for root partion
### Install yay
git clone git@tuanna:atuan26/dotfiles.git

```
pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
```

- [Ibus bamboo](https://github.com/BambooEngine/ibus-bamboo?tab=readme-ov-file#c%C3%A0i-%C4%91%E1%BA%B7t-t%E1%BB%AB-openbuildservice)

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/BambooEngine/ibus-bamboo/master/archlinux/install.sh)"
```
Partition manager: `sudo pacman -S gparted`

### Install google-chrome

```
yay -S --noconfirm google-chrome
yay -S --noconfirm flatpak
yay -S --noconfirm visual-studio-code-bin
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
sudo pacman -S neovim
sudo pacman -S less ttf-fira-code pacman-contrib tmux libreoffice-still

```
Add kitty desktop icon
```
mkdir ~/.local/bin/ || true 
# Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
# Place the kitty.desktop file somewhere it can be found by the OS
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty desktop file(s)
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
# Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
echo 'kitty.desktop' > ~/.config/xdg-terminals.list
```

### Docker

```
sudo pacman -S --noconfirm docker
sudo pacman -S --noconfirm docker-compose
sudo systemctl start docker.service
sudo systemctl enable docker.service
```


Fix permission: 
```
sudo usermod -aG docker $USER
newgrp docker
sudo chmod 777 /var/run/docker.sock

```

### ZSH
```
sudo pacman -S zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

sudo pacman -S unzip
sudo pacman -S fzf zoxide thefuck
sudo pacman -S ripgrep-all zip

```

### Git
pacman -S git-delta
- Key
```
ssh-keygen
touch ~/.ssh/config
```
- ~/.ssh/config:
```
Host tuanna
    HostName github.com
    User tuanna
    IdentityFile ~/.ssh/id_tuanna
```

### Python 
```
sudo pacman -S python-pip 
```
yay -S python-setuptools
Miniconda3
```
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
~/miniconda3/bin/conda init bash
~/miniconda3/bin/conda init zsh
```
### VSCODE
```
code --install-extension golf1052.code-sync
sudo chown -R $(whoami) $(which code) # /usr/bin/code  or /opt/visual-studio-code or /usr/share/code
```

TODO:
sudo pacman -S qt5-tools extra-cmake-modules

- crow translate: 
  - `git clone https://aur.archlinux.org/crow-translate.git && cd crow-translate && makepkg -si`
  - `ln -sf "$DOTFILES/config/Crow Translate/Crow Translate.conf" ~/.config/crow-translate/crow-translate.conf`

- warpd
- password-store
- insomia
- obsidian
- vscode
- docker, docker-compose


zsh
nvim
fzf
tmux
brew
ncdu
nnn
