{
  imports = [./modules/hm/all-modules.nix];

  home.stateVersion = "23.11";

  hm.systemd.enable = true;
  hm.xdg.enable = true;
  hm.stylix.enable = true;
  hm.iosevka.enable = true;
  hm.virt-manager.enable = true;
  hm.hyprland.enable = true;
  hm.fuzzel.enable = true;
  services.mako.enable = true;
  hm.foot.enable = true;
  hm.tmux.enable = true;
  programs.bash.enable = true;
  hm.fish.enable = true;
  hm.git.enable = true;
  hm.btop.enable = true;
  hm.man.enable = true;
  hm.comma.enable = true;
  hm.mdb.enable = true;
  hm.openvi.enable = true;
  hm.emacs.enable = true;
  programs.helix.enable = true;
  programs.vscode.enable = true;
  programs.texlive.enable = true;
  programs.k9s.enable = true;
  hm.openssh.enable = true;
  hm.gnupg.enable = true;
  hm.yubikey.enable = true;
  hm.gopass.enable = true;
  hm.firefox.enable = true;
  hm.chromium.enable = true;
  hm.chrome.enable = true;
  hm.imv.enable = true;
  hm.yt-dlp.enable = true;
  hm.mpv.enable = true;
  hm.obs-studio.enable = true;
  hm.games.enable = true;
  hm.misc.enable = true;
}
