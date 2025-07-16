{
  config,
  lib,
  ...
}:
let
  cfg = config.traits.hm.chawan;
in
{
  options.traits.hm.chawan = {
    enable = lib.mkEnableOption "chawan" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.chawan = {
      enable = true;
      settings = {
        # https://git.sr.ht/~bptato/chawan/tree/HEAD/doc/config.md
        buffer = {
          images = true;
          autofocus = true;
        };
        pager."C-k" = "() => pager.load('https://duckduckgo.com/?=')";
      };
    };
  };
}
