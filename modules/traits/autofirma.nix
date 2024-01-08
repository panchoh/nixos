{
  config,
  lib,
  autofirma-nix,
  ...
}:
with lib; let
  cfg = config.traits.autofirma;
in {
  imports = [autofirma-nix.nixosModules.default];

  options.traits.autofirma.enable = mkEnableOption "autofirma";

  config = mkIf cfg.enable {
    programs.autofirma.fixJavaCerts = true;
  };
}
