{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.vscode;
in
{
  options.traits.hm.vscode = {
    enable = lib.mkEnableOption "vscode" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vscode.enable = true;
  };
}
