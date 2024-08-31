{
  config,
  lib,
  autofirma-nix,
  box ? null,
  ...
}: let
  cfg = config.traits.os.autofirma;
in {
  imports = [
    autofirma-nix.nixosModules.default
  ];

  options.traits.os.autofirma = {
    enable = lib.mkEnableOption "autofirma" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    programs.autofirma.fixJavaCerts = true;
  };
}
