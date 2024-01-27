{
  config,
  lib,
  pkgs,
  attrs ? null,
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
        assertion = attrs.userName != "";
        message = "userName not defined";
      }
    ];

    # Define a user account. Don't forget to set a password with ‘passwd’.
    # users.mutableUsers = false;
    # TODO: set ssh keys elsewhere (attrs?)
    users.groups."storage".members = [attrs.userName or "alice"];
    users.users.${attrs.userName or "alice"} = {
      isNormalUser = true;
      description = attrs.userDesc or "Alice Q. User";
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
