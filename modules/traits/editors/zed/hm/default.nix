{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.zed;
in
{
  options.traits.hm.zed = {
    enable = lib.mkEnableOption "Zed" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
      ];

      userKeymaps = [
        {
          context = "VimControl && !menu";
          bindings = {
            "space c a" = "editor::ToggleCodeActions";
            "space f f" = "file_finder::Toggle";
            "space f s" = "workspace::Save";
            "space f p" = "zed::OpenSettings";
            "space o p" = "project_panel::ToggleFocus";
            "space o t" = "terminal_panel::ToggleFocus";
            "space q q" = "zed::Quit";
            "space w 1" = [
              "workspace::ActivatePane"
              0
            ];
            "space w 2" = [
              "workspace::ActivatePane"
              1
            ];
            "space w 3" = [
              "workspace::ActivatePane"
              2
            ];
            "space w 4" = [
              "workspace::ActivatePane"
              3
            ];
            "space w 5" = [
              "workspace::ActivatePane"
              4
            ];
            "space w 6" = [
              "workspace::ActivatePane"
              5
            ];
            "space w 7" = [
              "workspace::ActivatePane"
              6
            ];
            "space w 8" = [
              "workspace::ActivatePane"
              7
            ];
            "space w 9" = [
              "workspace::ActivatePane"
              8
            ];
            "space w c" = "pane::CloseActiveItem";
            "space w d" = "pane::CloseActiveItem";
            "space w h" = "workspace::ActivatePaneLeft";
            "space w j" = "workspace::ActivatePaneDown";
            "space w l" = "workspace::ActivatePaneRight";
            "space w k" = "workspace::ActivatePaneUp";
            "space w s" = "pane::SplitHorizontal";
            "space w v" = "pane::SplitVertical";
          };
        }
      ];

      userSettings = {
        auto_update = false;
        autosave = "on_focus_change";
        always_treat_brackets_as_autoclosed = true;
        disable_ai = true;
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
