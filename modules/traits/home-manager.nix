{
  config,
  lib,
  home-manager,
  nix-index-database,
  stylix,
  autofirma-nix,
  attrs ? null,
  ...
}: let
  cfg = config.traits.home-manager;
in {
  imports = [home-manager.nixosModules.default];

  options.traits.home-manager = {
    enable = lib.mkEnableOption "Home Manager";
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      backupFileExtension = "backup";
      verbose = true;
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit nix-index-database stylix autofirma-nix attrs;
      };
      users.${attrs.userName or "alice"} = import ../hm;
    };
  };
}
