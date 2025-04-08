{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.zed;
in {
  options.traits.hm.zed = {
    enable = lib.mkEnableOption "zed.dev" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
      ];
      userSettings = {
        auto_update = false;
        autosave = "on_focus_change";
        always_treat_brackets_as_autoclosed = true;
        features = {
          copilot = false;
        };
        telemetry = {
          metrics = false;
        };
        vim_mode = true;
        ui_font_size = lib.mkForce 16;
        buffer_font_size = lib.mkForce 16;
        # lsp.gopls.formatting.gofumpt = true;
        lsp.gopls.initialization_options.gofumpt = true;
      };
    };
  };
}
