{
  config,
  lib,
  ...
}: let
  cfg = config.traits.hm.texlive;
in {
  options.traits.hm.texlive = {
    enable = lib.mkEnableOption "texlive" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.texlive.enable = true;
  };
}
