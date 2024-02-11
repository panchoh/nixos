{
  config,
  lib,
  autofirma-nix,
  ...
}: let
  cfg = config.traits.autofirma;
in {
  imports = [
    autofirma-nix.nixosModules.default
  ];

  options.traits.autofirma = {
    enable = lib.mkEnableOption "autofirma" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.autofirma.fixJavaCerts = true;
  };
}
