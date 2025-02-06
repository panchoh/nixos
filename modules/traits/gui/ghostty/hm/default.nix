{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.ghostty;
in {
  options.traits.hm.ghostty = {
    enable = lib.mkEnableOption "ghostty" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;
      installBatSyntax = true;
      settings = {
        window-decoration = false;
      };
    };
  };
}
