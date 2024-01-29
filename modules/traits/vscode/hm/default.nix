{
  config,
  lib,
  ...
}: let
  cfg = config.hm.vscode;
in {
  options.hm.vscode = {
    enable = lib.mkEnableOption "vscode" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.vscode.enable = true;
  };
}
