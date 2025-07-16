{
  config,
  lib,
  ...
}:
let
  cfg = config.traits.hm.btop;
in
{
  options.traits.hm.btop = {
    enable = lib.mkEnableOption "btop" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.btop = {
      enable = true;
      settings = {
        # https://github.com/aristocratos/btop#configurability
        vim_keys = true;
      };
    };
  };
}
