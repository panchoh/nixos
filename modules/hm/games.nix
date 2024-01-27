{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.games;
in {
  options.hm.games.enable = lib.mkEnableOption "games" // {default = true;};

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bb
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
      crawl
      sl
      neofetch
      hyperrogue
    ];
  };
}
