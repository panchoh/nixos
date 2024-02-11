{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.user;
in {
  options.traits.user = {
    enable = lib.mkEnableOption "user" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = box.userName != "";
        message = "userName not defined";
      }
    ];

    # Define a user account. Don't forget to set a password with ‘passwd’.
    # users.mutableUsers = false;
    users.groups."storage".members = [box.userName or "alice"];
    users.users.${box.userName or "alice"} = {
      isNormalUser = true;
      description = box.userDesc or "Alice Q. User";
      extraGroups = ["wheel" "docker" "audio"];
      shell = pkgs.fish;
      initialPassword = "password";
      openssh.authorizedKeys.keys = box.userKeys;
    };
  };
}
