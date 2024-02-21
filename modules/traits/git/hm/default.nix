{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.git;
in {
  options.traits.hm.git = {
    enable = lib.mkEnableOption "git" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bvi
      diffoscope
      git-doc
      gitg
      gti
      gitui
      gittyup
      gource
      tig
      meld
      vbindiff
    ];

    programs.git = {
      enable = true;
      userName = box.userDesc or "Alice Q. User";
      userEmail = box.userEmail or "alice@example.org";
      extraConfig = {
        init.defaultBranch = "main";
        merge.conflictStyle = "zdiff3";
        github.user = box.githubUser or "aliceq";
      };
      delta = {
        enable = true;
        options.side-by-side = true;
      };
      signing = {
        key = box.gpgSigningKey;
        signByDefault = true;
      };
    };

    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
      extensions = [pkgs.gh-eco];
    };
  };
}
