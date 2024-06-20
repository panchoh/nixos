{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.chrome;
in {
  options.traits.hm.chrome = {
    enable = lib.mkEnableOption "Chromium" // {default = box.isStation or false;};
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
