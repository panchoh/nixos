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
    enable = lib.mkEnableOption "kmscon" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    services.kmscon = {
      enable = true;
      hwRender = true;
      autologinUser = box.userName or "alice";
      extraOptions = "--xkb-layout=us --xkb-variant=altgr-intl";
      # TODO: report issue upstream (single font requires trailing comma)
      fonts = lib.mkBefore [
        {
          # name = "IosevkaTerm NFM Light,"; # commas save lives!
          name = "IosevkaTerm NFM Light";
          package = pkgs.nerdfonts.override {fonts = ["IosevkaTerm"];};
        }
      ];
    };
  };
}
