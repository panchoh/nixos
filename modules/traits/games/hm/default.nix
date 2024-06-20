{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.games;
in {
  options.traits.hm.games = {
    enable = lib.mkEnableOption "games" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      abuse
      bb
      crawl
      sl
      neofetch
      hyperrogue
      # bsdgames # provides wtf, but conflicts with fish shell
      # FIXME: PR with the current BSD Games, which fixes this an more
      (stdenv.mkDerivation {
        pname = "bsdgames-custom";
        version = pkgs.bsdgames.version;
        src = pkgs.bsdgames;
        installPhase = ''
          mkdir -p $out
          cp -a ${pkgs.bsdgames}/. $out/
          chmod +w $out/bin
          mv -f $out/bin/fish $out/bin/gofish
        '';
      })
    ];
  };
}
