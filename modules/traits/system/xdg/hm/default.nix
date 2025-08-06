{
  config,
  lib,
  ...
}:
let
  cfg = config.traits.hm.xdg;
in
{
  options.traits.hm.xdg = {
    enable = lib.mkEnableOption "XDG" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.preferXdgDirectories = true;

    # Identify mime type with `xdg-mime query filetype ./path/to/foobar.baz`
    # .desktop files are located in /etc/profiles/per-user/${user}/share/applications/*.desktop
    # xdg.mimeApps.defaultApplications = {
    #   "application/foobar" = [ "org.some.App.desktop" ];
    # };

    xdg = {
      enable = true;
      mimeApps.enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        download = "${config.home.homeDirectory}/incoming";
        # TODO: decide what to do with the rest (disable most of them?)
      };
    };
  };
}
