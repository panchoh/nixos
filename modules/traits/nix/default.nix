{
  config,
  lib,
  nixpkgs,
  ...
}: let
  cfg = config.traits.nix;
in {
  options.traits.nix = {
    enable = lib.mkEnableOption "nix" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    # NIX_PATH is still used by many useful tools, such as Doom Emacs,  so we
    # set it to the same value as the one used by this flake.  Make `nix repl
    # '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
    environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";

    nix = {
      channel.enable = false;

      registry.nixpkgs.flake = nixpkgs;

      settings = {
        # https://nixos.org/manual/nix/unstable/command-ref/conf-file
        auto-optimise-store = true;
        use-xdg-base-directories = true;
        keep-outputs = true;
        show-trace = true;
        experimental-features = [
          "nix-command"
          "flakes"
          "repl-flake" # TODO: remove once nix 1.19 percolates to NixOS
        ];
        # https://github.com/NixOS/nix/issues/9574
        nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
      };

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };
    };
  };
}
