{
  config,
  lib,
  ...
}: let
  cfg = config.hm.btop;
in {
  options.hm.btop = {
    enable = lib.mkEnableOption "btop" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.btop = {
      enable = true;
      settings = {
        # https://github.com/aristocratos/btop#configurability
        vim_keys = true;
        color_theme = "dracula";
      };
    };
  };
}
