{
  config,
  lib,
  ...
}: let
  cfg = config.traits.hm.neovim;
in {
  config = lib.mkIf cfg.enable {
    xdg.configFile."nvim/lua/disable_keys.lua".source = ./disable_keys.lua;

    programs.nixvim.extraConfigLua = ''
      require("disable_keys").setup()
    '';
  };
}
