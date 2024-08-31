{
  config,
  lib,
  autofirma-nix,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.autofirma;
in {
  imports = [
    autofirma-nix.homeManagerModules.default
  ];

  options.traits.hm.autofirma = {
    enable = lib.mkEnableOption "autofirma" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    programs.autofirma = {
      enable = true;
      firefoxIntegration.profiles.default.enable = config.traits.hm.firefox.enable;
    };

    programs.configuradorfnmt = {
      enable = true;
      firefoxIntegration.profiles.default.enable = config.traits.hm.firefox.enable;
    };
  };
}
