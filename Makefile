TARGET := /etc/nixos
HOST   := nietzsche
FLAKE  := $(TARGET)\#$(HOST)

# Mirror the repo into $(TARGET), deleting files there that are not in the repo.
RSYNC_FLAGS := -rlptD --delete --chown=root:root \
	--exclude=.git --exclude=Makefile --exclude=.codex \
	--exclude=.claude --exclude=CLAUDE.md

.DEFAULT_GOAL := help
.PHONY: help diff install build dry-build test switch boot check \
	update update-input generations rollback gc optimise

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

## --- Sync -------------------------------------------------------------

diff: ## Preview what install would change in /etc/nixos
	sudo rsync $(RSYNC_FLAGS) --dry-run --itemize-changes ./ $(TARGET)/

install: ## Copy the repo to /etc/nixos, replacing its contents
	sudo rsync $(RSYNC_FLAGS) ./ $(TARGET)/

## --- Build / activate -------------------------------------------------

check: ## Evaluate the flake and run its checks (from the repo)
	nix flake check

build: ## Build the system from the repo without installing (./result)
	nixos-rebuild build --flake .#$(HOST)

dry-build: ## Show what would be built/downloaded (from the repo)
	nixos-rebuild dry-build --flake .#$(HOST)

test: install ## Install and activate now, but don't add a boot entry
	sudo nixos-rebuild test --flake $(FLAKE)

switch: install ## Install, activate now and make it the boot default
	sudo nixos-rebuild switch --flake $(FLAKE)

boot: install ## Install and make it the boot default on next reboot
	sudo nixos-rebuild boot --flake $(FLAKE)

## --- Flake inputs -----------------------------------------------------

update: ## Update all flake inputs (flake.lock)
	nix flake update

update-input: ## Update one input: make update-input INPUT=nixpkgs
	@test -n "$(INPUT)" || { echo "usage: make update-input INPUT=<name>"; exit 1; }
	nix flake update $(INPUT)

## --- Generations / cleanup --------------------------------------------

generations: ## List system generations
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

rollback: ## Switch back to the previous generation
	sudo nixos-rebuild switch --rollback

gc: ## Delete generations older than 14 days and collect garbage
	sudo nix-collect-garbage --delete-older-than 14d

optimise: ## Deduplicate files in the nix store
	sudo nix-store --optimise
