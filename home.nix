{
  config,
  pkgs,
  ...
}: {
  home.username = "pancho";
  home.homeDirectory = "/home/pancho";

  home.stateVersion = "22.11";

  programs.home-manager.enable = true;
}
