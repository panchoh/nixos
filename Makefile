.PHONY: help
.PHONY: bump check
.PHONY: nixos-rebuild-switch nixos-rebuild-test nixos-rebuild-build
.PHONY: list-nixos-history wipe-nixos-history
.PHONY: list-home-manager-history wipe-home-manager-history
.PHONY: gc gc-all store-optimise
.PHONY: clean-firefox clean-chromium pristine

help:
	@echo 'Usage: make [target]'
	@echo
	@echo 'Targets:'
	@make -pRrq : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") { print $$1 }}' | sort --unique | awk '{ print "  " $$0 }'

bump:
	nix flake update --commit-lock-file

check:
	nix flake check --verbose

nixos-rebuild-switch:
	doas nixos-rebuild switch --verbose

nixos-rebuild-test:
	doas nixos-rebuild test --verbose

nixos-rebuild-build:
	doas nixos-rebuild switch --verbose

list-nixos-history:
	nix profile history --profile /nix/var/nix/profiles/system

diff-closures:
	nix profile diff-closures --profile /nix/var/nix/profiles/system

wipe-nixos-history:
	doas nix profile wipe-history --profile /nix/var/nix/profiles/system

list-home-manager-history:
	nix profile history --profile ~/.local/state/nix/profiles/home-manager

diff-home-manager-closures:
	nix profile diff-closures --profile ~/.local/state/nix/profiles/home-manager

wipe-home-manager-history:
	nix profile wipe-history --profile ~/.local/state/nix/profiles/home-manager

gc:
	nix store gc --verbose --print-build-logs --auto-optimise-store

gc-all: wipe-nixos-history wipe-home-manager-history gc

store-optimise:
	nix store optimise --verbose

clean-firefox:
	rm -rf ~/.afirma ~/.java ~/.mozilla

clean-chromium:
	rm -rf ~/.config/chromium ~/.cache/chromium

pristine: gc-all clean-firefox clean-chromium
