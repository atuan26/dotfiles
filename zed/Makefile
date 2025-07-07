# Makefile for Zed editor configuration

GREEN=\033[0;32m
YELLOW=\033[1;33m
RED=\033[0;31m
NC=\033[0m

ZED_CONFIG_DIR=$(HOME)/.config/zed
ZED_THEMES_DIR=$(ZED_CONFIG_DIR)/themes
ZED_SNIPPETS_DIR=$(ZED_CONFIG_DIR)/snippets

.PHONY: install install-copy uninstall snippets

install:
	@echo -e "$(GREEN)Installing Zed configuration...$(NC)"
	@mkdir -p $(ZED_CONFIG_DIR)
	@mkdir -p $(ZED_THEMES_DIR)
	@mkdir -p $(ZED_SNIPPETS_DIR)
	@ln -sf $(PWD)/settings.json $(ZED_CONFIG_DIR)/settings.json || echo -e "$(RED)Failed to symlink settings.json$(NC)"
	@ln -sf $(PWD)/keymap.json $(ZED_CONFIG_DIR)/keymap.json || echo -e "$(RED)Failed to symlink keymap.json$(NC)"
	@if [ -d themes ]; then \
		ln -sf $(PWD)/themes/* $(ZED_THEMES_DIR)/ || echo -e "$(RED)Failed to symlink themes$(NC)"; \
	fi
	@if [ -d snippets ]; then \
		ln -sf $(PWD)/snippets/* $(ZED_SNIPPETS_DIR)/ || echo -e "$(RED)Failed to symlink snippets$(NC)"; \
	fi
	@echo -e "$(GREEN)Zed configuration installed successfully!$(NC)"

install-copy:
	@echo -e "$(GREEN)Copying Zed configuration...$(NC)"
	@mkdir -p $(ZED_CONFIG_DIR)
	@mkdir -p $(ZED_THEMES_DIR)
	@mkdir -p $(ZED_SNIPPETS_DIR)
	@cp -f $(PWD)/settings.json $(ZED_CONFIG_DIR)/settings.json || echo -e "$(RED)Failed to copy settings.json$(NC)"
	@cp -f $(PWD)/keymap.json $(ZED_CONFIG_DIR)/keymap.json || echo -e "$(RED)Failed to copy keymap.json$(NC)"
	@if [ -d themes ]; then \
		cp -r themes/* $(ZED_THEMES_DIR)/ || echo -e "$(RED)Failed to copy themes$(NC)"; \
	fi
	@if [ -d snippets ]; then \
		cp -r snippets/* $(ZED_SNIPPETS_DIR)/ || echo -e "$(RED)Failed to copy snippets$(NC)"; \
	fi
	@echo -e "$(GREEN)Zed configuration copied successfully!$(NC)"

snippets:
	@echo -e "$(GREEN)Installing Zed snippets...$(NC)"
	@mkdir -p $(ZED_SNIPPETS_DIR)
	@if [ -d snippets ]; then \
		ln -sf $(PWD)/snippets/* $(ZED_SNIPPETS_DIR)/ || echo -e "$(RED)Failed to symlink snippets$(NC)"; \
		echo -e "$(GREEN)Snippets installed successfully!$(NC)"; \
	else \
		echo -e "$(YELLOW)No snippets directory found.$(NC)"; \
	fi

uninstall:
	@echo -e "$(YELLOW)Removing Zed configuration...$(NC)"
	@rm -f $(ZED_CONFIG_DIR)/settings.json
	@rm -f $(ZED_CONFIG_DIR)/keymap.json
	@rm -rf $(ZED_SNIPPETS_DIR)
	@echo -e "$(GREEN)Zed configuration removed successfully!$(NC)" 