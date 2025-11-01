# Makefile at repo root

GREEN=\033[0;32m
YELLOW=\033[1;33m
RED=\033[0;31m
NC=\033[0m

DEPS_FILE=deps/dependencies-arch.txt
AUR_DEPS_FILE=deps/dependencies-aur.txt
FLATPAK_DEPS_FILE=deps/dependencies-flatpak.txt
# Normalize locale to avoid warnings on systems without en_US.UTF-8
export LC_ALL=C
export LANG=C

.PHONY: all zsh tmux vscode kde service zed copy-all deps aur-deps flatpak-deps pass-init

all: zsh tmux vscode kde service zed

zsh:
	@echo -e "$(GREEN)Installing ZSH configs...$(NC)"
	@$(MAKE) zsh install || echo -e "$(RED)[ROOT] ZSH install failed.$(NC)"

tmux:
	@echo -e "$(GREEN)Installing tmux configs...$(NC)"
	@$(MAKE) -C tmux install || echo -e "$(RED)[ROOT] tmux install failed.$(NC)"

vscode:
	@echo -e "$(GREEN)Installing VSCode configs...$(NC)"
	@$(MAKE) -C vscode install || echo -e "$(RED)[ROOT] VSCode install failed.$(NC)"

kde:
	@echo -e "$(GREEN)Installing KDE configs...$(NC)"
	@$(MAKE) -C kde-profiles/kde install || echo -e "$(RED)[ROOT] KDE install failed.$(NC)"

service:
	@echo -e "$(GREEN)Installing services...$(NC)"
	@$(MAKE) -C service install || echo -e "$(RED)[ROOT] Service install failed.$(NC)"

zed:
	@echo -e "$(GREEN)Installing Zed configs...$(NC)"
	@$(MAKE) -C zed install || echo -e "$(RED)[ROOT] Zed install failed.$(NC)"

copy-all:
	@$(MAKE) -C zsh install-copy || echo -e "$(RED)[ROOT] ZSH copy failed.$(NC)"
	@$(MAKE) -C tmux install-copy || echo -e "$(RED)[ROOT] tmux copy failed.$(NC)"
	@$(MAKE) -C vscode install-copy || echo -e "$(RED)[ROOT] VSCode copy failed.$(NC)"
	@$(MAKE) -C kde-profiles/kde install-copy || echo -e "$(RED)[ROOT] KDE copy failed.$(NC)"
	@$(MAKE) -C service install-copy || echo -e "$(RED)[ROOT] Service copy failed.$(NC)"
	@$(MAKE) -C zed install-copy || echo -e "$(RED)[ROOT] Zed copy failed.$(NC)"

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
	# @echo -e "$(GREEN)Linking pass-store to ~/.password-store...$(NC)"
	# @if [ -d pass-store ]; then \
	# 	if [ -e $$HOME/.password-store ] && [ ! -L $$HOME/.password-store ]; then \
	# 		mv $$HOME/.password-store $$HOME/.password-store.bak && echo -e "$(YELLOW)Backed up existing .password-store.$(NC)"; \
	# 	fi; \
	# 	ln -sf $(PWD)/pass-store $$HOME/.password-store || echo -e "$(RED)Failed to symlink .password-store.$(NC)"; \
	# fi
	@echo -e "$(YELLOW)pass password store setup complete.$(NC)"

# Usage:
# make deps         # Install pacman packages
# make aur-deps     # Install AUR packages (requires yay)
# make flatpak-deps # Install Flatpak apps
# make all          # Set up dotfiles