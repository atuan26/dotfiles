# Dotfiles

My personal dotfiles configuration for various tools and environments.

## Overview

This repository contains configuration files for:
- **Shell**: Zsh configuration with aliases, functions, and external scripts
- **Terminal**: Tmux configuration with plugins
- **Editors**: VSCode and Zed editor settings
- **Desktop**: KDE Plasma configuration profiles
- **System**: System services and autostart applications
- **Dependencies**: Package lists for different platforms

## Installation

### Prerequisites

- **Arch Linux**: `pacman`, `yay` (for AUR packages), `flatpak`
- **Ubuntu/Debian**: `apt`, `snap` (optional)
- **macOS**: `brew`, `mas` (for App Store apps)
- **Windows**: `winget`, `chocolatey` (optional)

### Quick Install

```bash
# Clone the repository
git clone --recursive https://github.com/atuan26/dotfiles.git
cd dotfiles

# Install dependencies for your platform
make deps         # Install pacman packages (Arch Linux)
make aur-deps     # Install AUR packages (Arch Linux)
make flatpak-deps # Install Flatpak apps

# Install all configurations
make all
```

### Platform-Specific Installation

#### Arch Linux

**Initial Setup (Fresh Install)**

```bash
# Install essential build tools and git
sudo pacman -S --needed git base-devel

# Install yay (AUR helper)
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si

**Display Manager Setup**

```bash
# Install and enable ly display manager
sudo pacman -S ly
sudo systemctl enable ly.service
```

**Terminal Setup**

```bash
# Install kitty terminal
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Add kitty to PATH and create desktop entries
mkdir -p ~/.local/bin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
echo 'kitty.desktop' > ~/.config/xdg-terminals.list

```

**Docker Setup**

```bash
# Install Docker
sudo pacman -S --noconfirm docker docker-compose
sudo systemctl start docker.service
sudo systemctl enable docker.service

# Fix Docker permissions
sudo usermod -aG docker $USER
newgrp docker
sudo chmod 777 /var/run/docker.sock
```

**Zsh Setup**

```bash
# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
```

**Git Setup**

```bash
# Generate SSH key
ssh-keygen

# Create SSH config
touch ~/.ssh/config

# Add to ~/.ssh/config:
# Host tuanna
#     HostName github.com
#     User tuanna
#     IdentityFile ~/.ssh/id_tuanna
```

**Python Setup**

```bash
# Install Python tools
sudo pacman -S python-pip

# Install Miniconda
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
~/miniconda3/bin/conda init bash
~/miniconda3/bin/conda init zsh
```

**Additional Tools**

```bash
# Install partition manager
sudo pacman -S gparted

# Install Vietnamese input method (Ibus bamboo)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/BambooEngine/ibus-bamboo/master/archlinux/install.sh)"

# Install Crow Translate
git clone https://aur.archlinux.org/crow-translate.git
cd crow-translate && makepkg -si

# Link Crow Translate config
ln -sf "$DOTFILES/config/Crow Translate/Crow Translate.conf" ~/.config/crow-translate/crow-translate.conf
```

**Install Dotfiles**

```bash
# Clone and install dotfiles
git clone git@tuanna:atuan26/dotfiles.git
cd dotfiles

# Install dependencies
make deps         # pacman packages
make aur-deps     # AUR packages
make flatpak-deps # Flatpak apps

# Install all configurations
make all
```

#### Ubuntu/Debian

```bash
# Install dependencies (manual - no make target yet)
sudo apt update
sudo apt install -y zsh tmux git curl wget

# Install all configurations
make all

# Or install individual components
make zsh          # Zsh configuration
make tmux         # Tmux configuration
make vscode       # VSCode settings
make zed          # Zed editor settings
make service      # System services
```

#### macOS

```bash
# Install dependencies (manual - no make target yet)
brew install zsh tmux git curl wget

# Install all configurations
make all

# Or install individual components
make zsh          # Zsh configuration
make tmux         # Tmux configuration
make vscode       # VSCode settings
make zed          # Zed editor settings
```

#### Windows

```bash
# Install dependencies (manual - no make target yet)
winget install Microsoft.PowerShell
winget install Git.Git

# Install all configurations
make all

# Or install individual components
make zsh          # Zsh configuration (if using WSL)
make tmux         # Tmux configuration (if using WSL)
make vscode       # VSCode settings
make zed          # Zed editor settings
```

### Installation Options

#### Symlink vs Copy

By default, the installation creates symlinks to your dotfiles repository. This means changes to the repository will be reflected immediately in your system.

```bash
# Default: Create symlinks (recommended)
make all

# Alternative: Copy files instead of symlinking
make copy-all
```

#### Individual Components

You can install specific components without installing everything:

```bash
make zsh          # Zsh shell configuration
make tmux         # Tmux terminal multiplexer
make vscode       # VSCode editor settings
make zed          # Zed editor settings
make kde          # KDE Plasma desktop
make service      # System services and autostart
```

## Configuration Details

### Zsh Configuration

- **Location**: `~/.zshrc`, `~/.zsh/`
- **Features**: 
  - Custom aliases and functions
  - FZF integration
  - Git integration
  - External scripts for enhanced functionality

### Tmux Configuration

- **Location**: `~/.tmux.conf`
- **Features**:
  - Prefix highlighting
  - Custom keybindings
  - Plugin management

### VSCode Configuration

- **Location**: `~/.config/Code/User/`
- **Features**:
  - Custom settings
  - Keybindings
  - Extensions list
  - Code snippets

### Zed Configuration

- **Location**: `~/.config/zed/`
- **Features**:
  - Custom settings
  - Keybindings
  - Themes
  - Code snippets

### KDE Configuration

- **Location**: `~/.config/`
- **Features**:
  - Plasma desktop settings
  - Application configurations
  - Theme and appearance

### System Services

- **Location**: `~/.config/systemd/user/`
- **Features**:
  - Autostart applications
  - Background services
  - Display manager configuration

## Dependencies

### Arch Linux (`deps/dependencies-arch.txt`)
- Core system packages
- Development tools
- Desktop applications

### AUR Packages (`deps/dependencies-aur.txt`)
- Community packages
- Development tools
- Utilities

### Flatpak Apps (`deps/dependencies-flatpak.txt`)
- Sandboxed applications
- Development tools
- Productivity apps

## Maintenance

### Updating Dependencies

```bash
# Update package lists
make deps         # Update pacman packages
make aur-deps     # Update AUR packages
make flatpak-deps # Update Flatpak apps
```

### Backup and Restore

```bash
# Backup current configuration
cp -r ~/.config ~/.config.backup

# Restore from backup
cp -r ~/.config.backup ~/.config
```

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure you have write permissions to `~/.config/`
2. **Symlink Errors**: Remove existing configuration files before installing
3. **Missing Dependencies**: Install required packages for your platform
4. **Docker Permission Issues**: Run `sudo usermod -aG docker $USER` and restart your session

### Reset Configuration

```bash
# Remove all symlinked configurations
make -C zsh uninstall
make -C tmux uninstall
make -C vscode uninstall
make -C zed uninstall
make -C service uninstall
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the installation
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
