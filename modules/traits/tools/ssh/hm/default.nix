{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.traits.hm.openssh;
in
{
  options.traits.hm.openssh = {
    enable = lib.mkEnableOption "OpenSSH" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      package = pkgs.openssh;
      matchBlocks = {
        "ubuntu* k8s-*" = lib.hm.dag.entryBefore [ "*.vm" ] {
          user = "sysadmin";
          identityFile = "~/.ssh/keys.d/id_ed25519-sysadmin@ubuntu";
          extraOptions = {
            GlobalKnownHostsFile = "/dev/null";
            UserKnownHostsFile = "/dev/null";
            StrictHostKeyChecking = "no";
          };
        };
        "*.vm" = lib.hm.dag.entryAnywhere {
          extraOptions = {
            GlobalKnownHostsFile = "/dev/null";
            UserKnownHostsFile = "/dev/null";
            StrictHostKeyChecking = "no";
          };
          identityFile = "~/.ssh/keys.d/id_ed25519-wildcard.vm";
          proxyCommand = "nc ( string replace .vm '' %h ) %p";
        };
        "*" = {
          addKeysToAgent = "yes";
          serverAliveInterval = 60;
          controlMaster = "no";
          controlPersist = "yes";
          sendEnv = [ "LC_*" ];
          identitiesOnly = true;
          identityFile = [
            # "~/.ssh/keys.d/id_ed25519-%r@%h"
            "~/.ssh/keys.d/id_ed25519_openpgp_YubiKey_5C_Nano-%r@%h"
            "~/.ssh/keys.d/id_ed25519_sk_rk_YubiKey_5C_NFC_#1-%r@%h"
            "~/.ssh/keys.d/id_ed25519_sk_rk_YubiKey_5C_NFC_#2-%r@%h"
            "~/.ssh/keys.d/id_ed25519_sk_rk_YubiKey_C_Bio_#1-%r@%h"
            "~/.ssh/keys.d/id_ed25519_sk_rk_YubiKey_C_Bio_#2-%r@%h"
          ];
          extraOptions = {
            ExitOnForwardFailure = "yes";
            HostKeyAlgorithms = "ssh-ed25519";
            VisualHostKey = "yes";
          };
        };
      };
    };
  };
}
