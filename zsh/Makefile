# zsh/Makefile

GREEN=\033[0;32m
YELLOW=\033[1;33m
RED=\033[0;31m
BLUE=\033[1;34m
NC=\033[0m

# Use XDG config directory, fallback to ~/.config
XDG_CONFIG_HOME ?= $(HOME)/.config

ZSH_FILES = .zshrc .zshenv aliases
ZSH_TARGETS = $(addprefix $(XDG_CONFIG_HOME)/zsh/, $(ZSH_FILES))

BACKUP_SUFFIX = backup-$(shell date +%Y%m%d-%H%M%S)

.PHONY: install install-symlink install-copy

install: install-symlink

install-symlink:
	@echo -e "$(GREEN)[ZSH] Symlinking configs...$(NC)"
	@mkdir -p $(XDG_CONFIG_HOME)/zsh
	@status=0; \
	for file in $(ZSH_FILES); do \
		target="$(XDG_CONFIG_HOME)/zsh/$$file"; \
		source="$(PWD)/$$file"; \
		is_correct_link=false; \
		if [ -L "$$target" ]; then \
			abs_target=$$(realpath "$$target" 2>/dev/null || readlink -f "$$target"); \
			abs_source=$$(realpath "$$source" 2>/dev/null || readlink -f "$$source"); \
			if [ "$$abs_target" = "$$abs_source" ]; then \
				is_correct_link=true; \
			fi; \
		fi; \
		if $$is_correct_link; then \
			echo -e "$(YELLOW)[ZSH] $$target already correctly symlinked.$(NC)"; \
		else \
			if [ -e "$$target" ] || [ -L "$$target" ]; then \
				mv "$$target" "$$target.$(BACKUP_SUFFIX)" && echo -e "$(BLUE)[ZSH] Backed up $$target to $$target.$(BACKUP_SUFFIX)$(NC)"; \
			fi; \
			ln -sf "$$source" "$$target" || { echo -e "$(RED)[ZSH] Failed to symlink $$file$(NC)"; status=1; }; \
		fi; \
	done; \
	if [ $$status -eq 0 ]; then \
		echo -e "$(GREEN)[ZSH] All configs symlinked successfully.$(NC)"; \
	else \
		echo -e "$(RED)[ZSH] Some configs failed to symlink.$(NC)"; \
	fi

install-copy:
	@echo -e "$(GREEN)[ZSH] Copying configs...$(NC)"
	@mkdir -p $(XDG_CONFIG_HOME)/zsh
	@status=0; \
	for file in $(ZSH_FILES); do \
		target="$(XDG_CONFIG_HOME)/zsh/$$file"; \
		source="$(PWD)/$$file"; \
		if [ -L "$$target" ] && [ "$(readlink -f \"$$target\")" = "$$source" ]; then \
			echo -e "$(YELLOW)[ZSH] $$target is a symlink to $$source, replacing with a copy.$(NC)"; \
			rm "$$target"; \
		fi; \
		if [ -e "$$target" ]; then \
			mv "$$target" "$$target.$(BACKUP_SUFFIX)" && echo -e "$(BLUE)[ZSH] Backed up $$target to $$target.$(BACKUP_SUFFIX)$(NC)"; \
		fi; \
		cp -f $$source $$target || { echo -e "$(RED)[ZSH] Failed to copy $$file$(NC)"; status=1; }; \
	done; \
	if [ $$status -eq 0 ]; then \
		echo -e "$(GREEN)[ZSH] All configs copied successfully.$(NC)"; \
	else \
		echo -e "$(RED)[ZSH] Some configs failed to copy.$(NC)"; \
	fi 