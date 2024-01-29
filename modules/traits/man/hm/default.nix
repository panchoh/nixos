{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.man;
in {
  options.hm.man = {
    enable = lib.mkEnableOption "man" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      man-pages
      man-pages-posix
    ];

    programs.man = {
      enable = true;
      generateCaches = true;
    };
  };
}
