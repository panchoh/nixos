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
    # TODO: set ssh keys elsewhere (box?)
    users.groups."storage".members = [box.userName or "alice"];
    users.users.${box.userName or "alice"} = {
      isNormalUser = true;
      description = box.userDesc or "Alice Q. User";
      extraGroups = ["wheel" "libvirtd" "docker" "audio"];
      shell = pkgs.fish;
      initialPassword = "password";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhtv6KrJc04bydU2mj6j/V6g/g+RiY1+gTg9h4z3STm pancho"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOK1QiBQzjzVDZoyWwewN8U0B6QRn09dasbcyTI48dWL pancho@ipad"
      ];
    };
  };
}
