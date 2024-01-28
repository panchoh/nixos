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
    nix = {
      channel.enable = false;
      registry.nixpkgs.flake = nixpkgs;
      settings = {
        auto-optimise-store = true;
        use-xdg-base-directories = true;
        experimental-features = [
          "nix-command"
          "flakes"
          "repl-flake" # TODO: remove once nix 1.19 percolates to NixOS
        ];
      };

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };
    };
  };
}
