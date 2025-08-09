{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.ansible;
in
{
  options.traits.ansible = {
    enable = lib.mkEnableOption "ansible" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ansible
      ansible-lint
      ansible-language-server
      sshpass
      neo-cowsay
    ];
  };
}
