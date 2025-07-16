{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.user;
in
{
  options.traits.os.user = {
    enable = lib.mkEnableOption "user" // {
      default = true;
    };
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
    users.users.${box.userName or "alice"} = {
      isNormalUser = true;
      description = box.userDesc or "Alice Q. User";
      extraGroups = [ "wheel" ];
      shell = pkgs.fish;
      initialPassword = "password";
      openssh.authorizedKeys.keys = box.userKeys;
    };
  };
}
