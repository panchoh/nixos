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
      };
      delta = {
        enable = true;
        options.side-by-side = true;
      };
      # TODO: move this to makeBox @ flake.nix
      signing = {
        key = "4430F5028B19FAF4A40EC4E811E0447D4ABBA7D0";
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
