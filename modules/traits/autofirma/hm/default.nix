{
  config,
  lib,
  autofirma-nix,
  ...
}: let
  cfg = config.hm.autofirma;
in {
  imports = [
    autofirma-nix.homeManagerModules.default
  ];

  options.hm.autofirma = {
    enable = lib.mkEnableOption "autofirma" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.autofirma = {
      enable = true;
      firefoxIntegration.profiles.default.enable = config.hm.firefox.enable;
    };

    programs.configuradorfnmt = {
      enable = true;
      firefoxIntegration.profiles.default.enable = config.hm.firefox.enable;
    };
  };
}
