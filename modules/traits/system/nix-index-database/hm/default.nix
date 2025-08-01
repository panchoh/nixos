{
  config,
  lib,
  nix-index-database,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.nix-index-database;
in
{
  imports = [
    # Provides nix-locate
    nix-index-database.homeModules.nix-index
  ];

  options.traits.hm.nix-index-database = {
    enable = lib.mkEnableOption "nix-index-database" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      nix-index.enable = false; # command-not-found integration
      nix-index-database.comma.enable = false; # installs on nix profile
    };
  };
}
