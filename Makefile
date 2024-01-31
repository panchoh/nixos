.PHONY: bump nixos-rebuild-switch
.PHONY: list-nixos-history list-home-manager-history
.PHONY: gc-all pristine
.PHONY: gc gc-all clean-firefox pristine

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

wipe-nixos-history:
	doas nix profile wipe-history --profile /nix/var/nix/profiles/system

list-home-manager-history:
	nix profile history --profile ~/.local/state/nix/profiles/home-manager

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
