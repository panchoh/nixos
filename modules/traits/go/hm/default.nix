{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.hm.go;
in {
  options.traits.hm.go = {
    enable = lib.mkEnableOption "Go" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.sessionPath = [
      "$HOME/.local/bin.go"
    ];

    home.packages = with pkgs; [
      gotools
      go-tools
      gopls
      gofumpt
      gomodifytags
      gotests
      gore
      delve
      gdlv
    ];

    programs.go = {
      enable = true;
      goBin = ".local/bin.go";
    };
  };
}
