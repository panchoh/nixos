{
  config,
  lib,
  ...
}: let
  cfg = config.traits.hm.direnv;
in {
  options.traits.hm.direnv = {
    enable = lib.mkEnableOption "direnv" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      config = {
        global = {
          disable_stdin = true;
          strict_env = true;
          hide_env_diff = true;
        };
        whitelist = {
          # TODO: extract path/username; look for disko-and-funk
          exact = [
            "~/sandbox/panchoh/nixos"
          ];
        };
      };
      nix-direnv.enable = true;
    };
  };
}
