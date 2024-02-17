{
  config,
  lib,
  ...
}: let
  cfg = config.traits.hm.yt-dlp;
in {
  options.traits.hm.yt-dlp = {
    enable = lib.mkEnableOption "btop" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs = {
      aria2.enable = true;
      yt-dlp = {
        enable = true;
        settings = {
          embed-thumbnail = true;
          embed-subs = true;
          sub-langs = "all";
          downloader = "aria2c";
          downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
        };
      };
    };
  };
}
