# Makefile for dotfiles management with GNU Stow

GREEN=\033[0;32m
YELLOW=\033[1;33m
RED=\033[0;31m
BLUE=\033[1;34m
NC=\033[0m

# Stow configuration
STOW_DIR := $(PWD)
STOW_TARGET := $(HOME)
STOW := stow -v -d $(STOW_DIR) -t $(STOW_TARGET)

# Package lists
CONFIG_PACKAGES := zsh tmux git vscode zed service i3 polybar config shell
ALL_PACKAGES := $(CONFIG_PACKAGES)

# Dependency files
DEPS_FILE := deps/dependencies-arch.txt
AUR_DEPS_FILE := deps/dependencies-aur.txt
FLATPAK_DEPS_FILE := deps/dependencies-flatpak.txt

# Normalize locale to avoid warnings on systems without en_US.UTF-8
export LC_ALL=C
export LANG=C

.PHONY: help install uninstall restow check deps aur-deps flatpak-deps pass-init
.PHONY: install-zsh install-tmux install-git install-vscode install-zed install-service install-i3 install-polybar install-config install-shell

# Default target
help:
	@echo -e "$(GREEN)Dotfiles Management with GNU Stow$(NC)"
	@echo ""
	@echo -e "$(YELLOW)Available targets:$(NC)"
	@echo -e "  $(BLUE)install$(NC)        - Install all dotfile packages using stow"
	@echo -e "  $(BLUE)uninstall$(NC)      - Remove all stowed symlinks"
	@echo -e "  $(BLUE)restow$(NC)         - Restow all packages (useful after updates)"
	@echo -e "  $(BLUE)check$(NC)          - Dry-run to see what would be stowed"
	@echo -e "  $(BLUE)install-<pkg>$(NC)  - Install a specific package (e.g., make install-zsh)"
	@echo ""
	@echo -e "$(YELLOW)Dependency targets:$(NC)"
	@echo -e "  $(BLUE)deps$(NC)           - Install pacman dependencies"
	@echo -e "  $(BLUE)aur-deps$(NC)       - Install AUR dependencies (requires yay)"
	@echo -e "  $(BLUE)flatpak-deps$(NC)   - Install Flatpak dependencies"
	@echo -e "  $(BLUE)pass-init$(NC)      - Initialize password store"
	@echo ""
	@echo -e "$(YELLOW)Available packages:$(NC)"
	@for pkg in $(ALL_PACKAGES); do echo -e "  - $$pkg"; done

# Install all packages
install:
	@echo -e "$(GREEN)Installing all dotfiles with stow...$(NC)"
	@for pkg in $(ALL_PACKAGES); do \
		if [ -d "$$pkg" ]; then \
			echo -e "$(BLUE)Stowing $$pkg...$(NC)"; \
			$(STOW) $$pkg || echo -e "$(RED)Failed to stow $$pkg$(NC)"; \
		else \
			echo -e "$(YELLOW)Package $$pkg not found, skipping...$(NC)"; \
		fi; \
	done
	@echo -e "$(GREEN)All packages installed!$(NC)"

# Uninstall all packages
uninstall:
	@echo -e "$(YELLOW)Removing all stowed dotfiles...$(NC)"
	@for pkg in $(ALL_PACKAGES); do \
		if [ -d "$$pkg" ]; then \
			echo -e "$(BLUE)Unstowing $$pkg...$(NC)"; \
			$(STOW) -D $$pkg || echo -e "$(RED)Failed to unstow $$pkg$(NC)"; \
		fi; \
	done
	@echo -e "$(GREEN)All packages removed!$(NC)"

# Restow all packages (useful after updates)
restow:
	@echo -e "$(BLUE)Restowing all dotfiles...$(NC)"
	@for pkg in $(ALL_PACKAGES); do \
		if [ -d "$$pkg" ]; then \
			echo -e "$(BLUE)Restowing $$pkg...$(NC)"; \
			$(STOW) -R $$pkg || echo -e "$(RED)Failed to restow $$pkg$(NC)"; \
		fi; \
	done
	@echo -e "$(GREEN)All packages restowed!$(NC)"

# Dry-run to check what would be stowed
check:
	@echo -e "$(BLUE)Checking what would be stowed (dry-run)...$(NC)"
	@for pkg in $(ALL_PACKAGES); do \
		if [ -d "$$pkg" ]; then \
			echo -e "$(YELLOW)=== $$pkg ===$(NC)"; \
			stow -n -v -d $(STOW_DIR) -t $(STOW_TARGET) $$pkg 2>&1 || true; \
			echo ""; \
		fi; \
	done

# Individual package install targets
install-zsh:
	@echo -e "$(GREEN)Installing zsh...$(NC)"
	@$(STOW) zsh

install-tmux:
	@echo -e "$(GREEN)Installing tmux...$(NC)"
	@$(STOW) tmux

install-git:
	@echo -e "$(GREEN)Installing git...$(NC)"
	@$(STOW) git

install-vscode:
	@echo -e "$(GREEN)Installing vscode...$(NC)"
	@$(STOW) vscode

install-zed:
	@echo -e "$(GREEN)Installing zed...$(NC)"
	@$(STOW) zed

install-service:
	@echo -e "$(GREEN)Installing service...$(NC)"
	@$(STOW) service

install-i3:
	@echo -e "$(GREEN)Installing i3...$(NC)"
	@$(STOW) i3

install-polybar:
	@echo -e "$(GREEN)Installing polybar...$(NC)"
	@$(STOW) polybar

install-config:
	@echo -e "$(GREEN)Installing config...$(NC)"
	@$(STOW) config

install-shell:
	@echo -e "$(GREEN)Installing shell...$(NC)"
	@$(STOW) shell

# Dependency installation targets (unchanged from original)
deps:
	@echo -e "$(GREEN)Installing pacman dependencies from $(DEPS_FILE)...$(NC)"
	@if [ -s $(DEPS_FILE) ]; then \
		LC_ALL=C sudo pacman -Sy --needed --noconfirm $$(awk '{ sub(/#.*/,""); if (NF) print $$1 }' $(DEPS_FILE)) || echo -e "$(RED)Pacman dependency install failed.$(NC)"; \
	else \
		echo -e "$(YELLOW)No pacman dependencies listed.$(NC)"; \
	fi
	@echo -e "$(YELLOW)Pacman dependency installation complete.$(NC)"

aur-deps:
	@echo -e "$(GREEN)Installing AUR dependencies from $(AUR_DEPS_FILE)...$(NC)"
	@if [ -s $(AUR_DEPS_FILE) ]; then \
		if ! command -v yay >/dev/null 2>&1; then \
			echo -e "$(YELLOW)yay not found; installing yay-bin from AUR...$(NC)"; \
			LC_ALL=C sudo pacman -Sy --needed --noconfirm base-devel git || { echo -e "$(RED)Failed to install base-devel/git prerequisites.$(NC)"; exit 1; }; \
			tmpdir=$$(mktemp -d); \
			git clone https://aur.archlinux.org/yay-bin.git $$tmpdir/yay-bin || { echo -e "$(RED)Failed to clone yay-bin AUR repo.$(NC)"; exit 1; }; \
			cd $$tmpdir/yay-bin && makepkg -si --noconfirm || { echo -e "$(RED)Failed to build/install yay.$(NC)"; exit 1; }; \
			rm -rf $$tmpdir; \
		fi; \
		LC_ALL=C yay -Sy --needed --noconfirm $$(awk '{ sub(/#.*/,""); if (NF) print $$1 }' $(AUR_DEPS_FILE)) || echo -e "$(RED)Yay dependency install failed.$(NC)"; \
	else \
		echo -e "$(YELLOW)No AUR dependencies listed.$(NC)"; \
	fi
	@echo -e "$(YELLOW)Yay dependency installation complete.$(NC)"

flatpak-deps:
	@echo -e "$(GREEN)Installing Flatpak dependencies from $(FLATPAK_DEPS_FILE)...$(NC)"
	@if [ -s $(FLATPAK_DEPS_FILE) ]; then \
		flatpak install -y --noninteractive $$(awk '{ sub(/#.*/,""); if (NF) print $$1 }' $(FLATPAK_DEPS_FILE)) || echo -e "$(RED)Flatpak dependency install failed.$(NC)"; \
	else \
		echo -e "$(YELLOW)No Flatpak dependencies listed.$(NC)"; \
	fi
	@echo -e "$(YELLOW)Flatpak dependency installation complete.$(NC)"

pass-init:
	@echo -e "$(GREEN)Initializing password store as a git submodule...$(NC)"
	@git submodule update --init --recursive
	@echo -e "$(YELLOW)pass password store setup complete.$(NC)"