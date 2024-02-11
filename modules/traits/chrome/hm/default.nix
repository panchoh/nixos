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

  config = lib.mkIf cfg.enable {
    programs.google-chrome = {
      enable = true;
      commandLineArgs = [
        "--ozone-platform=wayland"
      ];
    };
  };
}
