{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.tv;
in
{
  options.traits.hm.tv = {
    enable = lib.mkEnableOption "Television" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      television = {
        enable = true;
        settings = {
          default_channel = "nix-search-tv";
          ui = {
            status_bar = {
              separator_open = "";
              separator_close = "";
            };
            theme = "dracula";
          };
        };
      };
      nix-search-tv = {
        enable = true;
        settings.experimental.render_docs_indexes.nvf = "https://notashelf.github.io/nvf/options.html";
      };
    };
  };
}
