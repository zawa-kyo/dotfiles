SHELL := /usr/bin/env bash

.PHONY: install install-bun source

# Ensure the target script is executable, then run it
define RUN_SCRIPT
@script=$(1); \
if [ ! -x "$$script" ]; then \
	echo "󰅙 $$script is not executable. Please run: chmod +x $$script"; \
	exit 1; \
fi; \
"$$script"
endef

# Run the dotfiles symlink setup
install:
	$(call RUN_SCRIPT,./scripts/install.sh)

# Link Bun globals and install Bun dependencies
install-bun:
	$(call RUN_SCRIPT,./scripts/install-bun.sh)

# Emit shell snippets for eval-style sourcing
source:
	@if [ -t 1 ]; then \
		echo "NOTE: This is auto-loaded from .zshrc, so you usually don't need to run it manually. If you do run it via make, use \`eval \"\$$(make -s source)\"\` to apply exports to the current shell." 1>&2; \
	else \
		$(call RUN_SCRIPT,./scripts/source.sh); \
	fi
