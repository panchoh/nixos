{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.games.misc;
in {
  options.traits.hm.games.misc = {
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
      notcurses

      figlet
      toilet
      banner

      neo-cowsay
      charasay

      # bsdgames:
      # - provides `wtf`, which conflicts with `fish` shell
      # - provides `banner`, which conflicts with `banner`
      # FIXME: PR with the current BSD Games, which fixes this and more
      (stdenv.mkDerivation {
        pname = "bsdgames-custom";
        version = pkgs.bsdgames.version;
        src = pkgs.bsdgames;
        installPhase = ''
          mkdir -p $out
          cp -a ${pkgs.bsdgames}/. $out/
          chmod +w $out/bin
          mv -f $out/bin/fish $out/bin/gofish
          mv -f $out/bin/banner $out/bin/bsdbanner
        '';
      })
    ];
  };
}