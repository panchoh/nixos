{
  config,
  lib,
  ...
}: let
  cfg = config.traits.hm.vscode;
in {
  options.traits.hm.vscode = {
    enable = lib.mkEnableOption "vscode" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.vscode.enable = true;
  };
}
