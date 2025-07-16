{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.git;
in
{
  options.traits.hm.git = {
    enable = lib.mkEnableOption "git" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bvi
      diffoscope
      git-doc
      git-dive
      git-town
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
        init.defaultBranch = "master";
        merge.conflictStyle = "zdiff3";
        github.user = box.githubUser or "aliceq";
      };
      delta = {
        enable = false;
        options.side-by-side = true;
      };
      difftastic = {
        enable = true;
        # background = "dark";
        display = "side-by-side-show-both";
      };
      signing = {
        key = box.gpgSigningKey;
        signByDefault = true;
      };
    };

    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
      extensions = [ pkgs.gh-eco ];
    };
  };
}
