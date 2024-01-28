{
  config,
  lib,
  ...
}: let
  cfg = config.traits.ssh;
in {
  options.traits.ssh = {
    enable = lib.mkEnableOption "ssh and mosh" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.mosh.enable = true;

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
