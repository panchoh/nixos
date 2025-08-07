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
        desktop = null;
        documents = null;
        download = "${config.home.homeDirectory}/incoming";
        # TODO: Handle Music/Libation (audiobooks)
        # music = null;
        pictures = null;
        publicShare = null;
        templates = null;
        videos = null;
        extraConfig = {
          XDG_REPOS_DIR = "${config.home.homeDirectory}/sandbox";
          XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/screenshots";
        };
      };
    };
  };
}
