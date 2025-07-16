{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.kmscon;
in
{
  options.traits.os.kmscon = {
    enable = lib.mkEnableOption "kmscon" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.kmscon = {
      enable = true;
      hwRender = true;
      autologinUser = box.userName or "alice";
      useXkbConfig = true;
    };
  };
}
