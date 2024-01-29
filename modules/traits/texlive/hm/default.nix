{
  config,
  lib,
  ...
}: let
  cfg = config.hm.texlive;
in {
  options.hm.texlive = {
    enable = lib.mkEnableOption "texlive" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.texlive.enable = true;
  };
}
