{
  config,
  lib,
  ...
}:
let
  cfg = config.traits.os.ssh;
in
{
  options.traits.os.ssh = {
    enable = lib.mkEnableOption "ssh and mosh" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.mosh.enable = true;

    programs.ssh.knownHosts = {
      # obtained by running `ssh-keyscan -t ed25519 github.com`
      "github.com".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    };

    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
}
