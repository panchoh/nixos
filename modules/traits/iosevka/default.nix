{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.iosevka;
in {
  options.traits.iosevka = {
    enable = lib.mkEnableOption "Iosevka" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = [
      (pkgs.iosevka.override {
        set = "Europa";
        privateBuildPlan = {
          family = "Iosevka Europa";
          weights = {
            Regular = {
              shape = 300;
              menu = 300;
              css = 300;
            };
          };
        };
      })

      (pkgs.iosevka.override {
        set = "EuropaTerm";
        privateBuildPlan = {
          family = "Iosevka Europa Term";
          spacing = "term";
          weights = {
            Regular = {
              shape = 300;
              menu = 300;
              css = 300;
            };
          };
        };
      })

      (pkgs.iosevka.override {
        set = "EuropaSlab";
        privateBuildPlan = {
          family = "Iosevka Europa Slab";
          serifs = "slab";
          weights = {
            Regular = {
              shape = 300;
              menu = 300;
              css = 300;
            };
          };
        };
      })

      (pkgs.iosevka.override {
        set = "EuropaAile";
        privateBuildPlan = {
          family = "Iosevka Europa Aile";
          spacing = "quasi-proportional";
          weights = {
            Regular = {
              shape = 300;
              menu = 300;
              css = 300;
            };
          };
        };
      })
    ];
  };
}
