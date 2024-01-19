{
  config,
  lib,
  nix-index-database,
  ...
}: let
  cfg = config.hm.comma;
in {
  imports = [
    nix-index-database.hmModules.nix-index
  ];

  options.hm.comma.enable = lib.mkEnableOption "comma";

  config = lib.mkIf cfg.enable {
    programs.nix-index.enable = true;
    programs.nix-index-database.comma.enable = true;
  };
}
