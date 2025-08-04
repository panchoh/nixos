{
  config,
  lib,
  home-manager,
  extraSpecialArgs,
  home,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.home-manager;
in
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  options.traits.os.home-manager = {
    enable = lib.mkEnableOption "Home Manager" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = box.userName != "";
        message = "userName not defined.";
      }
    ];

    home-manager = {
      inherit extraSpecialArgs;
      backupFileExtension = "backup";
      verbose = true;
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${box.userName or "alice"} = home;
    };
  };
}
