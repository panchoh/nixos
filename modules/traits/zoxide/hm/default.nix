{
  config,
  lib,
  ...
}: let
  cfg = config.traits.hm.zoxide;
in {
  options.traits.hm.zoxide = {
    enable = lib.mkEnableOption "zoxide" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      _ZO_ECHO = "1";
    };

    programs.zoxide = {
      enable = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
