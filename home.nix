{...}: {
  imports = [
    ./modules/hm/systemd.nix
    ./modules/hm/xdg.nix
    ./modules/hm/stylix.nix
    ./modules/hm/iosevka.nix
    ./modules/hm/virt-manager.nix
    ./modules/hm/hyprland.nix
    ./modules/hm/fuzzel.nix
    ./modules/hm/foot.nix
    ./modules/hm/tmux.nix
    ./modules/hm/gopass.nix
    ./modules/hm/fish.nix
    ./modules/hm/git.nix
    ./modules/hm/btop.nix
    ./modules/hm/man.nix
    ./modules/hm/comma.nix
    ./modules/hm/mdb.nix
    ./modules/hm/openvi.nix
    ./modules/hm/emacs.nix
    ./modules/hm/openssh.nix
    ./modules/hm/gnupg.nix
    ./modules/hm/yubikey.nix
    ./modules/hm/firefox.nix
    ./modules/hm/chromium.nix
    ./modules/hm/chrome.nix
    ./modules/hm/imv.nix
    ./modules/hm/yt-dlp.nix
    ./modules/hm/mpv.nix
    ./modules/hm/obs-studio.nix
    ./modules/hm/games.nix
    ./modules/hm/misc.nix
  ];

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
  hm.gopass.enable = true;
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
