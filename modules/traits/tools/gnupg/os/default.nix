{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.os.gnupg;
in {
  options.traits.os.gnupg = {
    enable = lib.mkEnableOption "gnupg" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        wayprompt = prev.wayprompt.overrideAttrs (old: {
          src = final.fetchFromGitHub {
            owner = "panchoh";
            repo = "wayprompt";
            rev = "a87ff0db228542f8964250a91136eb9e053274a";
            hash = "sha256-2dYPZGxb9TjKharSZYDM2lVSYz0UUxCki64hAyQdoac=";
          };
        });
      })
    ];
  };
}
