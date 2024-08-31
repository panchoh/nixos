{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.hm.man;
in {
  options.traits.hm.man = {
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
