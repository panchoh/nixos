{
  config,
  lib,
  ...
}: let
  cfg = config.hm.zoxide;
in {
  options.hm.zoxide = {
    enable = lib.mkEnableOption "zoxide" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      _ZO_ECHO = "1";
    };

    programs.zoxide.enable = true;
  };
}
