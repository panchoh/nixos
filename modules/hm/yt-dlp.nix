{
  config,
  lib,
  ...
}: let
  cfg = config.hm.yt-dlp;
in {
  options = {
    hm.yt-dlp.enable = lib.mkEnableOption "btop" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.aria2.enable = true;
    programs.yt-dlp = {
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
}
