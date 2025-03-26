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
      # TODO: uncomment when fixed
      # hyperrogue
      notcurses
      # TODO: uncomment when fixed
      # torus-trooper

      figlet
      toilet
      banner

      neo-cowsay
      charasay

      nbsdgames
      # bsdgames:
      # - provides `wtf`, which conflicts with `fish` shell
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
        '';
      })
    ];
  };
}
