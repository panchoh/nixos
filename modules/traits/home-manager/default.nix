{
  config,
  lib,
  home-manager,
  nix-index-database,
  stylix,
  autofirma-nix,
  hmModules,
  box ? null,
  ...
}: let
  cfg = config.traits.home-manager;
in {
  imports = [home-manager.nixosModules.default];

  options.traits.home-manager = {
    enable = lib.mkEnableOption "Home Manager" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = box.userName != "";
        message = "userName not defined.";
      }
    ];

    home-manager = {
      backupFileExtension = "backup";
      verbose = true;
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit nix-index-database stylix autofirma-nix box;
      };
      users.${box.userName or "alice"} = hmModules;
    };
  };
}
