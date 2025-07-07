# vscode/Makefile

GREEN=\033[0;32m
YELLOW=\033[1;33m
RED=\033[0;31m
BLUE=\033[1;34m
NC=\033[0m

VSCODE_DIR = $(HOME)/.config/Code/User
BACKUP_SUFFIX = backup-$(shell date +%Y%m%d-%H%M%S)

.PHONY: install install-symlink install-copy

install: install-symlink

install-symlink:
	@echo -e "$(GREEN)[VSCode] Symlinking configs...$(NC)"
	@mkdir -p $(VSCODE_DIR)
	@status=0; \
	for file in settings.json keybindings.json extensions.json; do \
		target="$(VSCODE_DIR)/$$file"; \
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
			echo -e "$(YELLOW)[VSCode] $$target already correctly symlinked.$(NC)"; \
		else \
			if [ -e "$$target" ] || [ -L "$$target" ]; then \
				mv "$$target" "$$target.$(BACKUP_SUFFIX)" && echo -e "$(BLUE)[VSCode] Backed up $$target to $$target.$(BACKUP_SUFFIX)$(NC)"; \
			fi; \
			ln -sf "$$source" "$$target" || { echo -e "$(RED)[VSCode] Failed to symlink $$file$(NC)"; status=1; }; \
		fi; \
	done; \
	if [ $$status -eq 0 ]; then \
		echo -e "$(GREEN)[VSCode] All configs symlinked successfully.$(NC)"; \
	else \
		echo -e "$(RED)[VSCode] Some configs failed to symlink.$(NC)"; \
	fi

install-copy:
	@echo -e "$(GREEN)[VSCode] Copying configs...$(NC)"
	@mkdir -p $(VSCODE_DIR)
	@for file in settings.json keybindings.json extensions.json; do \
		target="$(VSCODE_DIR)/$$file"; \
		if [ -e "$$target" ]; then \
			mv "$$target" "$$target.$(BACKUP_SUFFIX)" && echo -e "$(BLUE)[VSCode] Backed up $$target to $$target.$(BACKUP_SUFFIX)$(NC)"; \
		fi; \
		cp -f $(PWD)/$$file $$target || echo -e "$(RED)[VSCode] Failed to copy $$file$(NC)"; \
	done
	@echo -e "$(YELLOW)[VSCode] Copying done.$(NC)" 