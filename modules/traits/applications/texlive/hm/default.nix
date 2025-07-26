{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.texlive;
in
{
  options.traits.hm.texlive = {
    enable = lib.mkEnableOption "texlive" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.texlive = {
      enable = true;
      extraPackages = tpkgs: {
        inherit (tpkgs) scheme-full;
      };
    };
  };
}
