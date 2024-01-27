{
  config,
  lib,
  ...
}: let
  cfg = config.hm.chrome;
in {
  options.hm.chrome = {
    enable = lib.mkEnableOption "Chromium" // {default = true;};
  };

  config.programs.google-chrome = lib.mkIf cfg.enable {
    enable = true;
    commandLineArgs = [
      "--ozone-platform=wayland"
    ];
  };
}
