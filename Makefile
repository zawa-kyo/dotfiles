SHELL := /usr/bin/env bash

.PHONY: install source install-bun bun-sync brew-sync mise-sync-global-tools

install:
	mise run install

source:
	@mise run source

install-bun:
	mise run install-bun

bun-sync:
	mise run bun-sync

brew-sync:
	mise run brew-sync

mise-sync-global-tools:
	mise run mise-sync-global-tools
