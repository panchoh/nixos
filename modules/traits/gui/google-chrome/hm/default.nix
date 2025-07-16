{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.google-chrome;
in
{
  options.traits.hm.google-chrome = {
    enable = lib.mkEnableOption "Google Chrome" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.google-chrome = {
      enable = true;
      commandLineArgs = [
        "--ozone-platform=wayland"
      ];
    };
  };
}
