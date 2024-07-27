{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.kmscon;
in {
  options.traits.kmscon = {
    enable = lib.mkEnableOption "kmscon" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    services.kmscon = {
      enable = true;
      hwRender = true;
      autologinUser = box.userName or "alice";
      useXkbConfig = true;
      fonts = lib.mkBefore [
        {
          name = "IosevkaTerm NFM Light";
          package = pkgs.nerdfonts.override {fonts = ["IosevkaTerm"];};
        }
      ];
    };
  };
}
